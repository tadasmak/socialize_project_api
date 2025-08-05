module Participants
  module BusinessRules
    class ActivityParticipantsLimit
      def initialize(activity, user)
        @activity = activity
        @user = user
      end

      def valid?
        @activity.participants.count < @activity.max_participants
      end

      def error_message
        "Maximum number of participants reached"
      end
    end
  end
end
