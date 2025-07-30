module Activities
  class ParticipationService
    def initialize(activity, user)
      @activity = activity
      @user = user
    end

    def join!
      participant = @activity.participant_records.build(user: @user)
      participant.save!
      Activities::StatusManager.new(@activity).sync_status
    end

    def leave!
      participant = @activity.participant_records.find_by!(user_id: @user.id)
      participant.destroy!
      Activities::StatusManager.new(@activity).sync_status
    end
  end
end
