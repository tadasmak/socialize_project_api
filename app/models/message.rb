class Message < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  valdiates :body, presence: true, length: { maximum: 5000 }
end
