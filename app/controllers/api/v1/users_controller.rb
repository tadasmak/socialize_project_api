class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render status: :ok, json: user
  end
end
