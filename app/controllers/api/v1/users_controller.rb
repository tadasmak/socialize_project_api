class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]

  def show
    render status: :ok, json: @user
  end

  def update
    @user.update(user_update_params)

    render status: :ok, json: @user
  end

  def destroy
    @user.destroy

    render status: :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "User not found" }
  end

  def user_update_params
    params.permit([ :personality, :username ])
  end
end
