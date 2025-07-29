module Activities
  class ParticipationService
    def initialize(activity, user)
      @activity = activity
      @user = user
    end

    def join!
      participant = @activity.participant_records.build(user: @user)
      participant.save!
    end

    def leave!
      participant = @activity.participant_records.find_by!(user_id: @user.id)
      participant.destroy!
    end
  end
end
