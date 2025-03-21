class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action -> { authorize_user!(current_user) }, only: [ :update, :destroy ]

  def show
    render status: :ok, json: @user
  end

  def update
    if current_user.update(user_update_params)
      render statys: :ok, json: current_user
    else
      render status: :unprocessable_entity, json: { errors: current_user.errors }
    end
  end

  def destroy
    if current_user.destroy
      render status: :no_content
    else
      render status: :unprocessable_entity, json: { errors: current_user.errors }
    end
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
