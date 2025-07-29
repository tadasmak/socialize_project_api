class Api::V1::ActivitiesController < ApplicationController
  include ActivitiesConcern

  skip_before_action :authenticate_user!, only: [ :index, :show ]

  before_action :set_activity, only: [ :show, :update, :destroy, :join, :leave, :set_confirmed_status, :set_cancelled_status ]
  before_action -> { authorize_user!(@activity.creator) }, only: [ :update, :destroy, :set_confirmed_status, :set_cancelled_status ]

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
    render_validation_errors(e)
  end

  def update
    @activity.update!(activity_params)

    render status: :ok, json: @activity
  rescue ActiveRecord::RecordInvalid => e
    render_validation_errors(e)
  end

  def destroy
    ActiveRecord::Base.transaction do
      @activity.mark_for_destruction
      @activity.participant_records.each(&:destroy!)
      @activity.destroy!
    end

    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render_validation_errors(e)
  end

  def join
    participant = @activity.participant_records.build(user: current_user)
    participant.save!

    render status: :created, json: { message: "You have joined the activity" }
  rescue ActiveRecord::RecordInvalid => e
    render_validation_errors(e)
  end

  def leave
    participant = @activity.participant_records.find_by!(user_id: current_user.id)
    participant.destroy!

    render status: :ok, json: { message: "You have left the activity" }
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "You are not a participant in this activity" }
  rescue ActiveRecord::RecordNotDestroyed => e
    render_validation_errors(e)
  end

  def generate_description
    title = params[:title]
    location = params[:location]
    start_time = params[:start_time]

    return render status: :bad_request, json: { error: "Title is required" } if title.blank?

    request_id = SecureRandom.uuid
    GenerateDescriptionJob.perform_later(request_id, title, location, start_time)
    render status: :ok, json: { request_id: request_id }
  end

  def description_status
    request_id = params[:request_id]
    return render status: :not_found, json: { error: "Missing request_id" } if request_id.blank?

    key = "description:#{request_id}"
    result = $redis.get(key)

    if result.nil?
      render status: :bad_request, json: { status: "not_found", message: "No such request ID found" }
    elsif result == "PENDING"
      render status: :ok, json: { status: "pending", message: request_id }
    elsif result == "ERROR"
      render status: :unprocessable_entity, json: { status: "error", message: "Description generation failed" }
    else
      render status: :ok, json: { status: "completed", description: result }
    end
  end

  def set_confirmed_status
    activity_status_manager = Activities::StatusManager.new(@activity)

    if activity_status_manager.mark_as_confirmed
      render status: :ok, json: { message: "Activity is now confirmed" }
    else
      render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
    end
  end

  def set_cancelled_status
    activity_status_manager = Activities::StatusManager.new(@activity)

    if activity_status_manager.mark_as_cancelled
      render status: :ok, json: { message: "Activity is now cancelled" }
    else
      render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "Activity not found" }
  end

  def activity_params
    params.require(:activity).permit(permitted_activity_attributes)
  end

  def permitted_activity_attributes
    [ :title, :description, :location, :start_time, :max_participants, :minimum_age, :maximum_age ]
  end

  def render_validation_errors(exception)
    render status: :unprocessable_entity, json: { errors: exception.record.errors.full_messages }
  end

  def handle_invalid_filtering(exception)
    render status: :unprocessable_entity, json: { error: exception.message }
  end
end
