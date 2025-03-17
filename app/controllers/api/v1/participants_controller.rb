class Api::V1::ParticipantsController < ApplicationController
  before_action :set_activity

  def create
    participant = @activity.participants.build(user: current_user)

    if participant.save
      render status: :created, json: "User joined the activity"
    else
      render status: :unprocessable_entity, json: { errors: participant.errors }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :unprocessable_entity, json: { error: "User already participates in this activity" }
  end

  def destroy
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
    @activity = Activity.find(params[:activity_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "Activity not found" }
  end
end
