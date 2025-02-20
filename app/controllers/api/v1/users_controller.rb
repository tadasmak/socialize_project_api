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

  def update
    user = User.find(params[:id])
    user.update(user_update_params)

    render status: :ok, json: user
  end

  private

  def user_create_params
    params.permit(permitted_user_attributes + [ :email ])
  end

  def user_update_params
    params.permit(permitted_user_attributes)
  end

  def permitted_user_attributes
    [ :personality, :username ]
  end
end
