class User < ApplicationRecord
  has_many :created_activities, class_name: 'Activity', foreign_key: 'user_id'
  has_many :participants
  has_many :joined_activities, through: :participants, source: :activity
end
