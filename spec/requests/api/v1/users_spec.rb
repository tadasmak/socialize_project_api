require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }
  let!(:valid_token) { sign_in(user) }

  describe "POST /api/v1/users" do
    it "creates a new user" do
      expect {
        post api_v1_users_path,
        params: { user: attributes_for(:user) }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:success)
    end

    it "returns unprocessable content due to email already registered" do
      post api_v1_users_path, params: { user: attributes_for(:user, email: user.email) }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns a user" do
      get api_v1_user_path(user), headers: { "Authorization" => valid_token }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end
  end
end
