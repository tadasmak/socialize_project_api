require 'rails_helper'

RSpec.describe "Authorization", type: :request do
  let!(:user) { create(:user) }
  let!(:user_token) { sign_in(user) }
  let!(:activity) { create(:activity, user_id: user.id) }

  describe "Authorization for protected resources" do
    context "when a valid JWT token is provided" do
      it "returns success for PATCH /api/v1/activities" do
        patch api_v1_activity_path(activity),
              params: { title: "Updated title" },
              headers: { "Authorization" => user_token }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["title"]).to eq("Updated title")
      end
    end

    context "when a valid JWT token is provided but not authorized" do
      let(:other_user) { create(:user) }
      let(:other_user_token) { sign_in(other_user) }

      it "returns forbidden for PATCH /api/v1/activities" do
        patch api_v1_activity_path(activity),
              params: { title: "Updated title" },
              headers: { "Authorization" => other_user_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when an invalid JWT token is provided" do
      it "returns unauthorized for PATCH /api/v1/activities" do
        patch api_v1_activity_path(activity),
              params: { title: "Updated title" },
              headers: { "Authorization" => "Bearer invalid_token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when a JWT token is missing" do
      it "returns unauthorized for PATCH /api/v1/activities" do
        patch api_v1_activity_path(activity), params: { title: "Updated title" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
