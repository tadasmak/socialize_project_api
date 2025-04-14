class Participant < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validate :activity_participants_limit

  def activity_participants_limit
    errors.add(:base, "Maximum participants number reached") if activity.participants.count >= activity.max_participants
  end
end
