class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    render_unauthorized("JWT token missing") unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.jwt[:secret], true, algorithm: "HS256")
      user_id = decoded_token[0]["sub"]
      @current_user = User.find_by(id: user_id)

      render_unauthorized("JWT token's user not found") unless @current_user
    rescue JWT::ExpiredSignature
      render_unauthorized("JWT token has expired")
    rescue JWT::DecodeError
      render_unauthorized("JWT decoding error")
    end
  end

  def render_unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
