require 'rails_helper'

RSpec.describe "Activities API V1", type: :request do
  let!(:activity) { create(:activity) }
  let!(:user) { create(:user) }

  describe "GET /api/v1/activities" do
    it "returns all activities" do
      get api_v1_activities_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/activites/:id' do
    it 'returns an activity' do
      get api_v1_activity_path(activity)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/activities' do
    it 'creates a new activity' do
      expect {
        post api_v1_activities_path,
        params: attributes_for(:activity, user_id: user.id)
      }.to change(Activity, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH /api/v1/activities/:id' do
    it 'updates an activity' do
      patch api_v1_activity_path(activity)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /api/v1/activities/:id' do
    it 'deletes an activity' do
      expect {
        delete api_v1_activity_path(activity)
      }.to change(Activity, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
