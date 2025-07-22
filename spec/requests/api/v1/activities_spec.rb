require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe "Activities API V1", type: :request do
  let!(:user) { create(:user) }
  let!(:activity) { create(:activity, user_id: user.id) }
  let!(:valid_token) { sign_in(user) }

  # Test more cases, i.e. if:
  #   activity does not exist
  #   data validation is incorrect

  describe "GET /api/v1/activities" do
    it "returns all activities" do
      get api_v1_activities_path,
          headers: { "Authorization" => valid_token }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/activites/:id' do
    it 'returns an activity' do
      get api_v1_activity_path(activity),
          headers: { "Authorization" => valid_token }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/activities' do
    it 'creates a new activity' do
      expect {
        post api_v1_activities_path,
             params: attributes_for(:activity, user_id: user.id),
             headers: { "Authorization" => valid_token }
      }.to change(Activity, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH /api/v1/activities/:id' do
    it 'updates an activity' do
      patch api_v1_activity_path(activity),
            params: { title: "Updated title" },
            headers: { "Authorization" => valid_token }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["title"]).to eq("Updated title")
    end
  end

  describe 'DELETE /api/v1/activities/:id' do
    it 'deletes an activity' do
      expect {
        delete api_v1_activity_path(activity),
               headers: { "Authorization" => valid_token }
      }.to change(Activity, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST /api/v1/activities/:id/join' do
    let(:other_user) { create(:user) }
    let(:other_activity) { create(:activity, user_id: other_user.id) }

    it 'joins an activity' do
      expect {
        post join_api_v1_activity_path(other_activity),
             headers: { "Authorization" => valid_token }
      }.to change(Participant, :count).by(1)

      expect(response).to have_http_status(:success)
      expect(Participant.exists?(user_id: user.id, activity_id: other_activity.id)).to be(true)
    end
  end

  describe 'DELETE /api/v1/activities/:id/leave' do
    let(:other_user) { create(:user) }
    let(:other_activity) { create(:activity, user_id: other_user.id) }
    let!(:participant) { create(:participant, user_id: user.id, activity_id: other_activity.id) }

    it 'leaves an activity' do
      expect(Participant.exists?(user_id: user.id, activity_id: other_activity.id)).to be(true)

      expect {
        delete leave_api_v1_activity_path(other_activity),
               headers: { "Authorization" => valid_token }
      }.to change(Participant, :count).by(-1)

      expect(response).to have_http_status(:success)
      expect(Participant.exists?(user_id: user.id, activity_id: other_activity.id)).to be(false)
    end
  end

  describe 'POST /api/v1/activities/generate_description' do
    it 'generates description and checks status' do
      post generate_description_api_v1_activities_path,
           params: { title: activity.title, location: activity.location, start_time: activity.start_time },
           headers: { "Authorization" => valid_token }

      expect(response).to have_http_status(:success)
      post_body = JSON.parse(response.body)
      expect(post_body).to have_key("request_id")

      request_id = post_body["request_id"]

      get description_status_api_v1_activities_path,
          params: { request_id: request_id },
          headers: { "Authorization" => valid_token }

      expect(response).to have_http_status(:success)
      status_body = JSON.parse(response.body)
      expect(status_body["status"]).to eq("completed")
      expect(status_body["description"]).to be_a(String)
    end
  end
end
