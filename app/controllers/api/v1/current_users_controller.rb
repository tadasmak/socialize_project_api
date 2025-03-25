class Api::V1::CurrentUsersController < ApplicationController
  def show
    if current_user
      render status: :ok, json: current_user
    else
      render status: :unauthorized, json: { error: "No logged in user" }
    end
  end

  def update
    if current_user.update(user_update_params)
      render status: :ok, json: current_user
    else
      render status: :unprocessable_entity, json: { errors: current_user.errors }
    end
  end

  def destroy
    sign_out(current_user)

    if current_user.destroy
      render status: :no_content
    else
      render status: :unprocessable_entity, json: { errors: current_user.errors }
    end
  end

  private

  def user_update_params
    params.permit([ :personality, :username ])
  end
end
