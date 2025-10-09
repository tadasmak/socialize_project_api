class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity

  def index
    messages = @activity.messages.order(created_at: :asc).limit(100)
    render json: messages.as_json(
      only: [ :id, :body, :created_at ],
      include: { user: { only: [ :id, :username ] } }
    )
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end
end
