module Participants
  module BusinessRules
    class UserAgeCriteria
      def initialize(activity, user)
        @activity = activity
        @user = user
      end

      def valid?
        @activity.age_range.include?(@user.age)
      end

      def error_message
        "Sorry, this activity is only for participants aged #{@activity.minimum_age} to #{@activity.maximum_age}"
      end
    end
  end
end
