class Participant < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validate :activity_participants_limit
  validate :user_joined_activities_limit

  def activity_participants_limit
    errors.add(:base, "Maximum participants number reached") if activity.participants.count >= activity.max_participants
  end

  def user_joined_activities_limit
    errors.add(:base, "You can join only up to #{user.max_joined_activities_count} activities") if user.joined_activities.count >= user.max_joined_activities_count
  end
end
