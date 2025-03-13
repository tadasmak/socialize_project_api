require 'rails_helper'

RSpec.describe "Participants API V1", type: :request do
  let!(:user) { create(:user) }
  let!(:valid_token) { sign_in(user) }
  let!(:activity) { create(:activity, user: user) }

  describe "POST /api/v1/participants" do
    it "joins an activity" do
      expect {
        post api_v1_participants_path,
        params: { user_id: user.id, activity_id: activity.id },
        headers: { "Authorization" => valid_token },
        as: :json
      }.to change(Participant, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end
end
