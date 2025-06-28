class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render status: :ok, json: { message: "Logged in successfully", user: resource }
  end

  def respond_to_on_destroy
    if current_user
      render status: :ok, json: { message: "Logged out successfully" }
    else
      render status: :unauthorized, json: { errors: [ "User not found" ] }
    end
  end
end
