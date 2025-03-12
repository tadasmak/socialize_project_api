class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [ :show, :update, :destroy ]
  before_action -> { authorize_user!(@activity) }, only: [ :update, :destroy ]

  def index
    activities = Activity.all
    render json: activities
  end

  def show
    activity = Activity.find(params[:id])
    render status: :ok, json: activity
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
    activity = Activity.find(params[:id])
    activity.update(activity_update_params)

    render status: :ok, json: activity
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.delete

    render status: :no_content
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
    render status: :not_found, json: { error: "Activity not found" } unless @activity
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
