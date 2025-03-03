class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render status: :ok, json: { message: "User created successfully", user: resource }
    else
      render status: :unprocessable_entity, json: { errors: resource.errors.full_messages }
    end
  end
end
