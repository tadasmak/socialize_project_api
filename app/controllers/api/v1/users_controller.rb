class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show ]

  def show
    render status: :ok, json: @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "User not found" }
  end
end
