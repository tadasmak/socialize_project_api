class Participant < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  before_destroy :prevent_creator_leaving_own_activity

  validate :activity_participants_limit
  validate :user_joined_activities_limit
  validate :user_age_criteria

  validates :user_id, uniqueness: { scope: :activity_id, message: "You already participate in this activity" }

  private

  def activity_participants_limit
    errors.add(:base, "Maximum participants number reached") if activity.participants.count >= activity.max_participants
  end

  def user_joined_activities_limit
    errors.add(:base, "You can join only up to #{user.max_joined_activities_count} activities") if user.joined_activities.count >= user.max_joined_activities_count
  end

  def user_age_criteria
    errors.add(:base, "You do not fit activity age criteria") unless activity.age_range.include?(user.age)
  end

  def prevent_creator_leaving_own_activity
    if activity.user_id == user_id
      errors.add(:base, "You cannot leave your own activity")
      throw(:abort)
    end
  end
end
