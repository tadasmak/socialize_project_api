class Api::V1::ActivitiesController < ApplicationController
  include ActivitiesConcern

  skip_before_action :authenticate_user!, only: [ :index, :show ]

  before_action :set_activity, only: [ :show, :update, :destroy, :join, :leave, :set_confirmed_status ]
  before_action -> { authorize_user!(@activity.creator) }, only: [ :update, :destroy, :set_confirmed_status ]

  rescue_from ArgumentError, with: :handle_invalid_filtering

  def index
    cache_key = "activities/#{params.to_unsafe_h.hash}"
    activities = Rails.cache.fetch(cache_key, expires_in: 1.minute) { gather_activities(params) }

    render status: :ok, json: activities, each_serializer: ActivitySerializer
  end

  def show
    render status: :ok, json: @activity, serializer: ActivityDetailSerializer
  end

  def create
    ActiveRecord::Base.transaction do
      @activity = Activity.create!(activity_params.merge(user_id: current_user.id))

      @activity.participant_records.create!(user: current_user)
    end

    render status: :created, json: @activity
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    if @activity.update(activity_params)
      render status: :ok, json: @activity
    else
      render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
    end
  end

  def destroy
    if @activity.participants.destroy_all
      if @activity.destroy
        render status: :no_content
      else
        render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages, source: "activity" }
      end
    else
      render status: :unprocessable_entity, json: { errors: "Failed to delete participants", source: "participants" }
    end
  end

  def join
    participant = @activity.participant_records.build(user: current_user)

    if participant.save
      render status: :created, json: "User joined the activity"
    else
      render status: :unprocessable_entity, json: { errors: participant.errors.full_messages }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :conflict, json: { error: "User already participates in this activity" }
  end

  def leave
    participant = @activity.participant_records.find_by(user_id: current_user.id)

    if participant.nil?
      render status: :not_found, json: { error: "You are not a participant in this activity" }
    elsif participant.destroy
      render status: :ok, json: { message: "You left the activity" }
    else
      render status: :unprocessable_entity, json: { error: participant.errors.full_messages }
    end
  end

  def generate_description
    title = params[:title]
    location = params[:location]
    start_time = params[:start_time]

    return render json: { error: "Title is required" }, status: :bad_request if title.blank?

    request_id = SecureRandom.uuid
    GenerateDescriptionJob.perform_later(request_id, title, location, start_time)
    render json: { request_id: request_id }
  end

  def description_status
    request_id = params[:request_id]
    return render json: { error: "Missing request_id" }, status: :bad_request if request_id.blank?

    result = $redis.get("description:#{request_id}")

    if result.nil?
      render json: { status: "pending", message: request_id }
    elsif result == "ERROR"
      render json: { status: "error", message: "Description generation failed" }
    else
      render json: { status: "done", description: result }
    end
  end

  def set_confirmed_status
    activity_status_manager = ActivityStatusManager.new(@activity)

    result = activity_status_manager.mark_as_confirmed

    case result
    when :success
      render status: :ok, json: { message: "Activity is now confirmed" }
    when :ok
      render status: :ok, json: { message: "Activity was already confirmed" }
    when :ineligible
      render status: :bad_request, json: { errors: "Activity must have full status" }
    when :invalid
      render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
    else
      render status: :internal_server_error, json: { errors: "Unexpected error" }
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "Activity not found" }
  end

  def activity_params
    params.permit(permitted_activity_attributes)
  end

  def permitted_activity_attributes
    [ :title, :description, :location, :start_time, :max_participants, :minimum_age, :maximum_age ]
  end

  def handle_invalid_filtering(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
