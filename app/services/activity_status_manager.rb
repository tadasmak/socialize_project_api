class ActivityStatusManager
  def initialize(activity)
    @activity = activity
  end

  def mark_as_full
    return false unless can_be_marked_full?

    @activity.update(status: :full)
  end

  def mark_as_open
    return false unless can_be_marked_open?

    @activity.update(status: :open)
  end

  def mark_as_confirmed!
    raise AlreadyConfirmedError if @activity.status == "confirmed"
    raise NotFullError unless @activity.status == "full"
    raise TooEarlyError unless @activity.start_time < Date.today + 1.week

    @activity.update!(status: :confirmed)
  end

  def mark_as_cancelled!
    raise AlreadyCancelledError if @activity.status == "cancelled"

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
