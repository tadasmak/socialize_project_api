module AuthenticationHelper
  def sign_in(user)
    post "/api/v1/users/sign_in", params: { user: { email: user.email, password: user.password } }
    response.headers["Authorization"]
  end
end
