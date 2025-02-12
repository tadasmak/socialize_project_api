class Api::V1::ActivitiesController < ApplicationController
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

  private

  def activity_create_params
    params.require(:activity).permit(permitted_activity_attributes + [ :user_id ])
  end

  def activity_update_params
    params.require(:activity).permit(permitted_activity_attributes)
  end

  def permitted_activity_attributes
    [ :title, :description, :location, :start_time, :max_participants ]
  end
end
