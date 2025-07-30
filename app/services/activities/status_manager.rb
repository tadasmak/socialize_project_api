module Activities
  class StatusManager
    def initialize(activity)
      @activity = activity
    end

    def sync_status
      if can_be_marked_full?
        @activity.update!(status: :full)
      elsif can_be_marked_open?
        @activity.update!(status: :open)
      end
    end

    def update_status(status)
      return false if status_already_set?(status)
      return false unless valid_status_transition?(status)

      @activity.update!(status:)
    end

    private

    def status_already_set?(status)
      if @activity.status == status
        @activity.errors.add(:status, "is already #{status}")
        true
      else
        false
      end
    end

    def valid_status_transition?(status)
      case status
      when Activity.statuses[:confirmed]
        unless @activity.full?
          @activity.errors.add(:status, "can only be confirmed if full")
          return false
        end

        unless @activity.start_time < 1.week.from_now
          @activity.errors.add(:start_time, "must be within one week of start date to confirm")
          return false
        end
      else
        @activity.errors.add(:status, "is not a valid status update")
        return false
      end

      true
    end

    def can_be_marked_full?
      @activity.open? && @activity.participants.count >= @activity.max_participants
    end

    def can_be_marked_open?
      @activity.full? && @activity.participants.count < @activity.max_participants
    end
  end
end
