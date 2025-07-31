module Activities
  module BusinessRules
    class UserUpcomingActivitiesLimit
      MAX_CREATED_ACTIVITIES_COUNT = 3

      def initialize(creator)
        @creator = creator
      end

      def valid?
        @creator.created_activities.upcoming.count < MAX_CREATED_ACTIVITIES_COUNT
      end

      def error_message
        "You can only create #{MAX_CREATED_ACTIVITIES_COUNT} activities that are yet to take place at a time"
      end
    end
  end
end
