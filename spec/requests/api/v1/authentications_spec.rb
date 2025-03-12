require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /api/v1/users/sign_in" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post "/api/v1/users/sign_in", params: {
          user: {
            email: user.email,
            password: user.password
          }
        }

        expect(response).to have_http_status(:ok)
        token = response.headers["Authorization"]

        expect(token).to be_present
        expect(token).to match(/^Bearer\s.+/)
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post "/api/v1/users/sign_in", params: {
          email: user.email,
          password: "wrong_password"
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/users/sign_out" do
    context "when logged in" do
      it "logs out the user" do
        post "/api/v1/users/sign_in", params: {
          user: {
            email: user.email,
            password: user.password
          }
        }

        token = response.headers["Authorization"]

        delete "/api/v1/users/sign_out", headers: {
          "Authorization" => token
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context "when no token is provided" do
      it "returns unauthorized error" do
        delete "/api/v1/users/sign_out"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
