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

  describe "POST /api/v1/users/sign_out" do
    
  end
end
