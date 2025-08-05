module Users
  module BusinessRules
    class AgeLimit
      MIN_AGE = 18
      MAX_AGE = 99

      def initialize(user)
        @user = user
      end

      def valid?
        return true unless @user.birth_date.present?

        if @user.age < MIN_AGE
          @error_message = "must be at least #{MIN_AGE} years"
          return false
        elsif @user.age > MAX_AGE
          @error_message = "cannot exceed #{MAX_AGE} years"
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
