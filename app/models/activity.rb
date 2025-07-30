class Activity < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :participant_records, class_name: "Participant", dependent: :delete_all
  has_many :participants, through: :participant_records, source: :user

  enum :status, %i[open full confirmed cancelled]

  scope :upcoming, -> { where("start_time > ?", Time.now) }

  validates :title, presence: true,
                    format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                    length: { minimum: 8, maximum: 100 }
  validates :description, presence: true,
                          format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                          length: { minimum: 20, maximum: 300 }
  validates :location, presence: true,
                       format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                       length: { minimum: 4, maximum: 100 }
  validates :start_time, presence: true
  validates :max_participants, presence: true,
                               inclusion: { in: 2..8, message: "must be between 2 and 8" }
  validates :minimum_age, presence: true, numericality: { greater_than_or_equal_to: 18,
                                                          less_than_or_equal_to: 100,
                                                          message: "must be between 18 and 100" }
  validates :maximum_age, presence: true, numericality: { greater_than_or_equal_to: 18,
                                                          less_than_or_equal_to: 100,
                                                          message: "must be between 18 and 100" }
  validate :start_time_cannot_be_in_past
  validate :start_time_cannot_be_too_far_in_future
  validate :age_range_order
  validate :age_range_span
  validate :creator_within_age_range
  validate :created_activities_per_user_limit, if: :new_record?

  def age_range
    (minimum_age..maximum_age)
  end

  def participants_count
    participant_records.count
  end

  private

  def start_time_cannot_be_in_past
    errors.add(:start_time, "should be in the future") if start_time < Time.current
  end

  def start_time_cannot_be_too_far_in_future
    errors.add(:start_time, "must be no further that 1 month in the future") if start_time > 1.month.from_now
  end

  def age_range_order
    errors.add(:minimum_age, "cannot be greater than maximum age") if minimum_age > maximum_age
  end

  def creator_within_age_range
    errors.add(:creator, "must be inside the age range") unless age_range.include?(creator.age)
  end

  def age_range_span
    rule = Activities::BusinessRules::AgeRangeLimit.new(self)
    errors.add(:age_range, rule.error_message) unless rule.valid?
  end

  def created_activities_per_user_limit
    activities_count = creator.created_activities.upcoming.count
    max_activities_count = creator.max_upcoming_created_activities_count

    errors.add(:base, "You can only create #{max_activities_count} activities that are yet to take place at a time") if activities_count >= max_activities_count
  end
end
