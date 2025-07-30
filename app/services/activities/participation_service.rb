module Activities
  class ParticipationService
    def initialize(activity, user)
      @activity = activity
      @user = user
    end

    def join!
      validate_participation!
      @activity.participant_records.create!(user: @user)
      Activities::StatusManager.new(@activity).sync_status
    end

    def leave!
      participant = @activity.participant_records.find_by(user_id: @user.id)
      raise ActiveRecord::RecordNotFound, "You are not a participant in this activity" unless participant

      participant.destroy!
      Activities::StatusManager.new(@activity).sync_status
    end

    private

    def validate_participation!
      if @activity.participant_records.exists?(user_id: @user.id)
        raise ActiveRecord::RecordNotUnique, "You already participate in this activity"
      end
    end
  end
end
