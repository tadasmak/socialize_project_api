module Activities
  module BusinessRules
    class StartTimeLimit
      MAX_FUTURE_TIME_SPAN = 1.month
      MIN_FUTURE_TIME_SPAN = 1.week

      def initialize(activity)
        @activity = activity
      end

      def valid?
        if @activity.start_time < MIN_FUTURE_TIME_SPAN.from_now
          @error_message = "must be at least #{MIN_FUTURE_TIME_SPAN.inspect} from now"
          return false
        elsif @activity.start_time > MAX_FUTURE_TIME_SPAN.from_now
          @error_message = "must be no further than #{MAX_FUTURE_TIME_SPAN.inspect} in the future"
          return false
        end

        true
      end

      def error_message
        @error_message
      end
    end
  end
end
