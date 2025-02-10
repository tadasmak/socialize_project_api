class Activity < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  has_many :participants
  has_many :users, through: :participants
end
