class ActivityChannel < ApplicationCable::Channel
  def subscribed
    @activity = Activity.find(params[:activity_id])
    stream_for @activity
  end

  def send_message(data)
    body = data["body"].to_s.strip
    return if body.blank?

    message = @activity.messages.create!(user: current_user, body:)

    ActivityChannel.broadcast_to(@activity, MessageSerializer.new(message).as_json)
  end
end
