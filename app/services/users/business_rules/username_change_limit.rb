module Users
  module BusinessRules
    class UsernameChangeLimit
      def initialize(user)
        @user = user
      end

      def valid?
        return true unless @user.will_save_change_to_username?

        !@user.username_changed
      end

      def error_message
        "can only be changed once"
      end
    end
  end
end
