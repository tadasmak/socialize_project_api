class ActivityStatusManager
  def initialize(activity)
    @activity = activity
  end

  def sync_status
    if can_be_marked_full?
      @activity.update(status: "full")
    elsif can_be_marked_open?
      @activity.update(status: "open")
    end
  end

  def mark_as_confirmed
    if @activity.status == "confirmed"
      @activity.errors.add(:base, "Activity is already confirmed")
      return false
    end

    unless @activity.status == "full"
      @activity.errors.add(:base, "Activity must have 'full' status")
      return false
    end

    unless @activity.start_time < Date.today + 1.week
      @activity.errors.add(:base, "Activity can only be confirmed within one week of the start date")
      return false
    end

    @activity.update!(status: :confirmed)
  end

  def mark_as_cancelled
    if @activity.status == "cancelled"
      @activity.errors.add(:base, "Activity is already cancelled")
      return false
    end

    @activity.update!(status: :cancelled)
  end

  private

  def can_be_marked_full?
    @activity.status == "open" && @activity.participants.count >= @activity.max_participants
  end

  def can_be_marked_open?
    @activity.status == "full" && @activity.participants.count < @activity.max_participants
  end
end
