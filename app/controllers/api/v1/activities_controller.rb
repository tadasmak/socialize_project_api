class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [ :show, :update, :destroy, :join, :leave ]
  before_action -> { authorize_user!(@activity) }, only: [ :update, :destroy ]

  def index
    activities = Activity.all
    render json: activities
  end

  def show
    render status: :ok, json: @activity
  end

  def create
    activity = Activity.new(activity_create_params)

    if activity.save
      render status: :created, json: activity
    else
      render status: :bad_request, json: { errors: activity.errors }
    end
  end

  def update
    @activity.update(activity_update_params)

    render status: :ok, json: @activity
  end

  def destroy
    @activity.destroy

    render status: :no_content
  end

  def join
    participant = @activity.participants.build(user: current_user)

    if participant.save
      render status: :created, json: "User joined the activity"
    else
      render status: :unprocessable_entity, json: { errors: participant.errors }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :unprocessable_entity, json: { error: "User already participates in this activity" }
  end

  def leave
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

  def activity_create_params
    params.permit(permitted_activity_attributes + [ :user_id ])
  end

  def activity_update_params
    params.permit(permitted_activity_attributes)
  end

  def permitted_activity_attributes
    [ :title, :description, :location, :start_time, :max_participants ]
  end
end
