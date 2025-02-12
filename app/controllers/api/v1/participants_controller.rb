class Api::V1::ParticipantsController < ApplicationController
  def create
    participant = Participant.new(participant_create_params)

    if participant.save
      render status: :created, json: participant
    else
      render status: :bad_request, json: { errors: participant.errors }
    end
  end

  private

  def participant_create_params
    params.permit(
      :activity_id,
      :user_id
    )
  end
end
