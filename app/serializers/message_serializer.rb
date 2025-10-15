class MessageSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :body, :created_at, :user

  def user
    {
      id: object.user.id,
      username: object.user.username
    }
  end
end
