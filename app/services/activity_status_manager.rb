class ActivityStatusManager
  def initialize(activity)
    @activity = activity
  end

  def mark_as_full
    return :ineligible unless can_be_marked_full?
    return :invalid unless @activity.update(status: :full)

    :success
  end

  def mark_as_open
    return :ineligible unless can_be_marked_open?
    return :invalid unless @activity.update(status: :open)

    :success
  end

  def mark_as_confirmed
    return :ineligible unless can_be_marked_confirmed?
    return :invalid unless @activity.update(status: :confirmed)

    :success
  end

  def mark_as_cancelled
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

  def can_be_marked_confirmed?
    @activity.status == "full"
  end

  def can_be_marked_cancelled?
    !@activity.cancelled?
  end
end
