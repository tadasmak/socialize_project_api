class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :start_time, :max_participants, :age_range, :created_at, :creator, :participants_count
  belongs_to :creator, serializer: UserSerializer
  has_many :participants, serializer: UserSerializer

  def age_range
    return nil unless object.minimum_age.present? && object.maximum_age.present?

    "#{object.minimum_age}-#{object.maximum_age}"
  end

  def participants_count
    object.participants&.count
  end
end
