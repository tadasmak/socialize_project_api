require 'rails_helper'

RSpec.describe "Participants API V1", type: :request do
  let!(:user) { create(:user) }
  let!(:activity) { create(:activity, user: user) }

  describe "POST /api/v1/participants" do
    it "joins an activity" do
      post api_v1_participants_path,
      params: { user_id: user.id, activity_id: activity.id }
      expect(response).to have_http_status(:success)
      expect(Participant.count).to eq(1)
    end
  end
end
