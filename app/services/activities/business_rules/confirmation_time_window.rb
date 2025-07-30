module Activities
  module BusinessRules
    class ConfirmationTimeWindow
      def initialize(activity)
        @activity = activity
      end

      def valid?
        @activity.start_time < 1.week.from_now
      end

      def error_message
        "must be within one week of start date to confirm"
      end
    end
  end
end
