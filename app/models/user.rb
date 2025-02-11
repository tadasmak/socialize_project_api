class User < ApplicationRecord
  has_many :created_activities, class_name: "Activity", foreign_key: "user_id"
  has_many :participants
  has_many :joined_activities, through: :participants, source: :activity

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
