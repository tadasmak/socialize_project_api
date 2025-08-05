module Users
  module BusinessRules
    class BirthDateSetLimit
      def initialize(user)
        @user = user
      end

      def valid?
        return true unless @user.will_save_change_to_birth_date?

        @user.birth_date_in_database.blank?
      end

      def error_message
        "can only be set once"
      end
    end
  end
end
