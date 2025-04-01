module ActivitiesConcern
  extend ActiveSupport::Concern

  def gather_activities
    process_activities(params)
  end

  private

  def process_activities(params)
  end
end
