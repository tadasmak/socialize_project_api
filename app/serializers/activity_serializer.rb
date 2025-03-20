class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :start_time, :max_participants, :created_at, :creator, :participants
  belongs_to :creator, serializer: UserSerializer
  has_many :participants, serializer: UserSerializer

  def participants
    object.users
  end
end
