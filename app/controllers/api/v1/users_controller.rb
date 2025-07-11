class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  before_action :set_user, only: [ :show ]

  def show
    render status: :ok, json: @user
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { errors: [ "User not found" ] }
  end
end
