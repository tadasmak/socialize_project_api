class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render status: :ok, json: user
  end

  def update
    user = User.find(params[:id])
    user.update(user_update_params)

    render status: :ok, json: user
  end

  def destroy
    user = User.find(params[:id])
    user.delete

    render status: :no_content
  end

  private

  def user_update_params
    params.permit([ :personality, :username ])
  end
end
