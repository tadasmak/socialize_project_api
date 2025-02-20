class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render status: :ok, json: user
  end

  def create
    user = User.create(user_create_params)

    if user.save
      render status: :created, json: user
    else
      render status: :bad_request, json: { errors: user.errors }
    end
  end

  private

  def user_create_params
    params.permit([ :email, :username, :personality ])
  end
end
