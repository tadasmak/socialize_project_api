class ActivityStatusManager
  def initialize(activity)
    @activity = activity
  end

  def mark_as_full
    @activity.update(status: "full") if can_be_marked_full?
  end

  def mark_as_open
    @activity.update(status: "open") if can_be_marked_open?
  end

  def mark_as_confirmed
    @activity.update(status: "confirmed") if can_be_marked_confirmed?
  end

  def mark_as_cancelled
    @activity.update(status: "cancelled") if can_be_marked_cancelled?
  end

  private

  def can_be_marked_full?
    @activity.status == "open" && @activity.participants.count >= @activity.max_participants
  end

  def can_be_marked_open?
    @activity.status == "full" && @activity.participants.count < @activity.max_participants
  end

  def can_be_marked_confirmed?
    @activity.status == "full"
  end

  def can_be_marked_cancelled?
    !@activity.cancelled?
  end
end
