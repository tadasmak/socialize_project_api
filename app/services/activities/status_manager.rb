module Activities
  class StatusManager
    def initialize(activity)
      @activity = activity
    end

    def sync_status # Auto transition of :full and :open status
      if can_be_marked_full?
        @activity.update!(status: :full)
      elsif can_be_marked_open?
        @activity.update!(status: :open)
      end
    end

    def update_status(status) # Manual transition of :confirmed and :cancelled status
      status_already_set?(status)
      valid_status_transition?(status.to_sym)

      @activity.update!(status:)
    end

    private

    def status_already_set?(status)
      if @activity.status == status
        @activity.errors.add(:status, "is already #{status}")
        raise ActiveRecord::RecordInvalid.new(@activity)
      end
    end

    def valid_status_transition?(status)
      case status
      when :confirmed
        unless @activity.full?
          @activity.errors.add(:status, "can only be confirmed if full")
          raise ActiveRecord::RecordInvalid.new(@activity)
        end

        rule = Activities::BusinessRules::ConfirmationTimeWindow.new(@activity)
        unless rule.valid?
          @activity.errors.add(:start_time, rule.error_message)
          raise ActiveRecord::RecordInvalid.new(@activity)
        end
      when :cancelled
        # No validation needed
      else
        @activity.errors.add(:status, "is not a valid status update")
        raise ActiveRecord::RecordInvalid.new(@activity)
      end
    end

    def can_be_marked_full?
      @activity.open? && @activity.participants.count >= @activity.max_participants
    end

    def can_be_marked_open?
      @activity.full? && @activity.participants.count < @activity.max_participants
    end
  end
end
