class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  has_many :created_activities, class_name: "Activity", foreign_key: "user_id"
  has_many :participants
  has_many :joined_activities, through: :participants, source: :activity

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX, message: "must be a valid email address" }
  validates :username, presence: true, uniqueness: true

  enum :personality, {
    very_introverted: 1,
    introverted: 2,
    slightly_introverted: 3,
    ambiverted: 4,
    slightly_extraverted: 5,
    extraverted: 6,
    very_extraverted: 7
  }
end
