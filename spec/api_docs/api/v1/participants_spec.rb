require 'swagger_helper'

RSpec.describe 'api/v1/participants', type: :request do
  path '/api/v1/participants' do
    post('Join activity') do
      tags 'Participants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id, in: :body, required: true, schema: { type: :integer, example: 5 }
      parameter name: :activity_id, in: :body, required: true, schema: { type: :integer, example: 1 }

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/Participant'

        let(:valid_params) { { user_id: 5, activity_id: 1 } }
        run_test!
      end
    end
  end
end
