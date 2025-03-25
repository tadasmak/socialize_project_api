require 'rails_helper'

# TODO: Move tests from users_spec.rb to current_user_spec.rb

RSpec.describe "Api::V1::CurrentUsers", type: :request do
  let!(:current_user) { create(:user) }
  let!(:valid_token) { sign_in(current_user) }

  describe "GET /api/v1/current_user" do
    it "returns currently logged in user's data" do
      get api_v1_current_user_path, headers: { "Authorization" => valid_token }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(current_user.id)
    end
  end

  describe "PATCH /api/v1/current_user" do
    let(:new_username) { 'updated_name' }

    it "updates a user" do
      patch api_v1_current_user_path,
      headers: { "Authorization" => valid_token },
      params: { username: new_username }

      expect(response).to have_http_status(:success)
      current_user.reload
      expect(current_user.username).to eq(new_username)
    end
  end

  describe "DELETE /api/v1/current_user" do
    it "delete a user" do
      expect {
        delete api_v1_current_user_path, headers: { "Authorization" => valid_token }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
