class ActivityStatusManager
  def initialize(activity)
    @activity = activity
  end

  def mark_as_full
    return :ok if @activity.full?
    return :ineligible unless can_be_marked_full?
    return :invalid unless @activity.update(status: :full)

    :success
  end

  def mark_as_open
    return :ok if @activity.open?
    return :ineligible unless can_be_marked_open?
    return :invalid unless @activity.update(status: :open)

    :success
  end

  def mark_as_confirmed!
    raise AlreadyConfirmedError if @activity.status == "confirmed"
    raise NotFullError unless @activity.status == "full"
    raise TooEarlyError unless @activity.start_time < Date.today + 1.week

    @activity.update!(status: :confirmed)
  end

  def mark_as_cancelled
    return :ok if @activity.cancelled?
    return :ineligible unless can_be_marked_cancelled?
    return :invalid unless @activity.update(status: :cancelled)

    :success
  end

  private

  def can_be_marked_full?
    @activity.status == "open" && @activity.participants.count >= @activity.max_participants
  end

  def can_be_marked_open?
    @activity.status == "full" && @activity.participants.count < @activity.max_participants
  end

  def can_be_marked_cancelled?
    !@activity.cancelled?
  end
end
