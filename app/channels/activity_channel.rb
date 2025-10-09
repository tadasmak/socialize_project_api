class ActivityChannel < ApplicationCable::Channel
  def subscribed
    @activity = Activity.find(params[:activity_id])
    reject unless current_user.member_of?(@activity)
    stream_for @activity
  end

  def send_message(data)
    body = data[:body].to_s.strip
    return if body.blank?

    message = @activity.messages.create!(user: current_user, body:)

    ActivityChannel.broadcast_to(@activity, {
      id: message.id,
      user_id: message.user_id,
      user_name: message.user.username,
      body: message.body,
      created_at: message.created_at.iso8601
    })
  end
end
