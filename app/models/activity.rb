class Activity < ApplicationRecord
  belongs_to :user
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
  validate :start_time_constraint
  validates :max_participants, presence: true, inclusion: { in: 2..8, message: "must be between 2 and 8" }

  def start_time_constraint
    errors.add(:start_time, "start_time does not exist") if start_time.blank?
    errors.add(:start_time, "start time should be in the future") if start_time < Time.now
    errors.add(:start_time, "must be no further that 1 month in the future") if start_time > 1.month.from_now
  end
end
