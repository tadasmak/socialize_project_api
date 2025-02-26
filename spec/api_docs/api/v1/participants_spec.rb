require 'swagger_helper'

RSpec.describe 'api/v1/participants', type: :request do
  path '/api/v1/participants' do
    post('Join activity') do
      tags 'Participants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :participant, in: :body, required: true, schema: {
        '$ref' => '#/components/schemas/ParticipantCreate'
      }

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/Participant'

        let(:valid_params) { { user_id: 5, activity_id: 1 } }
        run_test!
      end
    end
  end
end
