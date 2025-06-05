class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :start_time, :max_participants, :minimum_age, :maximum_age, :created_at, :creator, :participants_count
  belongs_to :creator, serializer: UserSerializer
  has_many :participants, serializer: UserSerializer

  def participants_count
    participants.count
  end
end
