class Api::V1::ActivitiesController < ApplicationController
  include ActivitiesConcern

  before_action :set_activity, only: [ :show, :update, :destroy, :join, :leave ]
  before_action -> { authorize_user!(@activity.creator) }, only: [ :update, :destroy ]

  rescue_from ArgumentError, with: :handle_invalid_filtering

  def index
    cache_key = "activities/#{params.to_unsafe_h.hash}"
    activities = Rails.cache.fetch(cache_key, expires_in: 1.minute) { gather_activities(params) }

    render json: activities
  end

  def show
    render status: :ok, json: @activity
  end

  def create
    activity = Activity.new(activity_params)
    activity.user_id = current_user.id

    if activity.save
      participant = activity.participants.build(user: current_user)

      if participant.save
        render status: :created, json: activity
      else
        render status: :unprocessable_entity, json: { source: "participant", errors: participant.errors }
      end
    else
      render status: :unprocessable_entity, json: { source: "activity", errors: activity.errors }
    end
  end

  def update
    if @activity.update(activity_params)
      render status: :ok, json: @activity
    else
      render status: :unprocessable_entity, json: { errors: @activity.errors }
    end
  end

  def destroy
    if @activity.participants.destroy_all
      if @activity.destroy
        render status: :no_content
      else
        render status: :unprocessable_entity, json: { errors: @activity.errors, source: "activity" }
      end
    else
      render status: :unprocessable_entity, json: { errors: "Failed to delete participants", source: "participants" }
    end
  end

  def join
    participant = @activity.participants.build(user: current_user)

    if participant.save
      render status: :created, json: "User joined the activity"
    else
      if participant.errors[:base].include?("Maximum participants number reached")
        render status: :conflict, json: { error: "Maximum participants number reached" }
      else
        render status: :unprocessable_entity, json: { errors: participant.errors }
      end
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :conflict, json: { error: "User already participates in this activity" }
  end

  def leave
    return render status: :conflict, json: { errors: "User cannot leave their own activity" } if @activity.user_id == current_user.id

    participant = @activity.participants.find_by(user_id: current_user.id)

    if participant
      participant.destroy
      render status: :ok, json: { message: "User left the activity" }
    else
      render status: :unprocessable_entity, json: { error: "User is not a part of this activity" }
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
