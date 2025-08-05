class Participant < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validates :user_id, uniqueness: { scope: :activity_id, message: "already participates in this activity" }, presence: true
  validate :activity_participants_limit
  validate :user_joined_activities_limit
  validate :user_age_criteria

  before_destroy :prevent_creator_leaving_own_activity, unless: -> { activity.marked_for_destruction? }

  private

  def activity_participants_limit
    rule = Participants::BusinessRules::ActivityParticipantsLimit.new(activity, user)
    errors.add(:base, rule.error_message) unless rule.valid?
  end

  def user_joined_activities_limit
    rule = Participants::BusinessRules::UserJoinedActivitiesLimit.new(user)
    errors.add(:base, rule.error_message) unless rule.valid?
  end

  def user_age_criteria
    rule = Participants::BusinessRules::UserAgeCriteria.new(activity, user)
    errors.add(:base, rule.error_message) unless rule.valid?
  end

  def prevent_creator_leaving_own_activity
    if activity.user_id == user_id
      errors.add(:base, "You cannot leave your own activity")
      throw(:abort)
    end
  end
end
