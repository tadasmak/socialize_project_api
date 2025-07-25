module ActivitiesConcern
  extend ActiveSupport::Concern

  def gather_activities(params)
    process_activities(params)
  end

  private

  def filter_offset(result, offset)
    result.offset(offset)
  end

  def filter_limit(result, limit)
    raise ArgumentError, "Limit must be between 1-10" unless limit > 0 && limit <= 10

    result.limit(limit)
  end

  def filter_query(result, query)
    return result unless query.present?

    query = query.downcase
    result.where("LOWER(title) LIKE :query OR
                  LOWER(description) LIKE :query OR
                  LOWER(location) LIKE :query",
                  query: "%#{query}%")
  end

  def process_activities(params)
    result = Activity.all

    # Any filters can be applied here, i.e.
    # filter_keywords(result, params[:keyword])

    query = params[:q].presence
    result = filter_query(result, query)

    # Activities pagination
    page = params[:page].presence&.to_i || 1
    limit = params[:limit].presence&.to_i || 10
    offset = (page - 1) * limit

    result = filter_offset(result, offset)
    result = filter_limit(result, limit)
  end
end
