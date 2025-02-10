class User < ApplicationRecord
  has_many :activities, foreign_key: 'created_by'
  has_many :participants
end
