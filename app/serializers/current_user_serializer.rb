class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :personality, :age, :birth_date, :bio
  has_many :created_activities, serializer: ActivitySerializer
  has_many :joined_activities, serializer: ActivitySerializer

  def joined_activities
    object.joined_activities.where.not(user_id: object.id).order(created_at: :desc)
  end
end
