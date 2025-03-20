class Participant < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  before_create :check_participants_limit

  def check_participants_limit
    if activity.participants.count >= activity.max_participants
      errors.add(:base, "Maximum participants number reached")
      throw(:abort)
    end
  end
end
