require 'rails_helper'

# TODO: Move tests from users_spec.rb to current_user_spec.rb

RSpec.describe "Api::V1::CurrentUsers", type: :request do
  let!(:current_user) { create(:user) }
  let!(:valid_token) { sign_in(current_user) }

  describe "GET /api/v1/current_user" do
    it "returns currently logged in user's data" do
      get api_v1_current_user_path(current_user), headers: { "Authorization" => valid_token }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(current_user.id)
    end
  end
end
