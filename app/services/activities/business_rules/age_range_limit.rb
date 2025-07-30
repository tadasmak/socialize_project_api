module Activities
  module BusinessRules
    class AgeRangeLimit
      MIN_SPAN = 4
      MAX_SPAN = 8

      def initialize(activity)
        @activity = activity
      end

      def valid?
        difference = @activity.maximum_age - @activity.minimum_age

        if difference < MIN_SPAN
          @error_message = "must span at least #{MIN_SPAN} years"
          return false
        elsif difference > MAX_SPAN
          @error_message = "cannot span more than #{MAX_SPAN} years"
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
