class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authorize_user!(resource)
    puts current_user.id

    render status: :forbidden, json: { error: "This resource is not assigned to any user" } if resource.user.nil?

    return if resource.user.id == current_user.id

    render status: :forbidden, json: { error: "You are not authorized to execute this action" }
  end
end
