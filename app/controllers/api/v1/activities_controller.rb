class Api::V1::ActivitiesController < ApplicationController
  def index
    activities = Activity.all
    render json: activities
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      render status: :created, json: @activity
    else
      render status: :bad_request, json: { errors: @activity.errors }
    end
  end

  private

  def activity_params
    params.permit(
      :title,
      :description,
      :location,
      :start_time,
      :max_participants,
      :user_id
    )
  end
end
