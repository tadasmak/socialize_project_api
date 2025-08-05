module Participants
  module BusinessRules
    class UserJoinedActivitiesLimit
      MAX_JOINED_ACTIVITIES_COUNT = 3

      def initialize(user)
        @user = user
      end

      def valid?
        @user.joined_activities.count < MAX_JOINED_ACTIVITIES_COUNT
      end

      def error_message
        "You can participate in only up to #{MAX_JOINED_ACTIVITIES_COUNT} activities"
      end
    end
  end
end
