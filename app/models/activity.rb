class Activity < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :participants
  has_many :users, through: :participants

  validates :title, presence: true,
                    format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                    length: { minimum: 8, maximum: 100 }
  validates :description, presence: true,
                          format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                          length: { minimum: 40, maximum: 1000 }
  validates :location, presence: true,
                       format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                       length: { minimum: 4, maximum: 100 }
  validates :max_participants, presence: true, inclusion: { in: 2..8, message: "must be between 2 and 8" }
  validates :minimum_age, presence: true, numericality: { greater_than_or_equal_to: 18,
                                                          less_than_or_equal_to: 100,
                                                          message: "must be between 18 and 100" }
  validates :maximum_age, presence: true, numericality: { greater_than_or_equal_to: 18,
                                                          less_than_or_equal_to: 100,
                                                          message: "must be between 18 and 100" }
  validate :age_range_logic

  validate :created_activities_per_user_limit
  validate :start_time_constraint

  scope :upcoming, -> { where("start_time > ?", Time.now) }

  def age_range
    (minimum_age..maximum_age)
  end

  private

  def start_time_constraint
    errors.add(:start_time, "start_time does not exist") if start_time.blank?
    errors.add(:start_time, "start time should be in the future") if start_time < Time.now
    errors.add(:start_time, "must be no further that 1 month in the future") if start_time > 1.month.from_now
  end

  def created_activities_per_user_limit
    return unless creator.present?

    activities_count = creator.created_activities.upcoming.count
    max_activities_count = creator.max_upcoming_created_activities_count

    errors.add(:base, "You can only create #{max_activities_count} activities that are yet to take place at a time") if activities_count >= max_activities_count
  end

  def age_range_logic
    return errors.add(:base, "Minimum age cannot be greater than maximum age") if minimum_age > maximum_age

    return errors.add(:base, "Creator must be inside the age range") if creator.age > maximum_age || creator.age < minimum_age

    errors.add(:base, "Age range must be no more than 9 years") if maximum_age - minimum_age > 9
  end
end
