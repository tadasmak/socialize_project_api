class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :start_time, :max_participants, :created_at, :user, :participants
  belongs_to :user, serializer: UserSerializer
  has_many :participants, serializer: UserSerializer

  def participants
    object.users
  end
end
