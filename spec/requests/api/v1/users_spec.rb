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

  describe "PATCH /api/v1/users/:id" do
    let(:new_username) { 'updated_name' }

    it "updates a user" do
      patch api_v1_user_path(user),
      headers: { "Authorization" => valid_token },
      params: { username: new_username }

      expect(response).to have_http_status(:success)
      user.reload
      expect(user.username).to eq(new_username)
    end
  end

  describe "DELETE /api/v1/users/:id" do
    it "delete a user" do
      expect {
        delete api_v1_user_path(user), headers: { "Authorization" => valid_token }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
