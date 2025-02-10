class User < ApplicationRecord
  has_many :created_activities, class_name: 'Activity', foreign_key: 'created_by'
  has_many :joined_activities, through: :participants, source: :activity
  has_many :participants
end
