require 'swagger_helper'

RSpec.describe 'api/v1/participants', type: :request do
  path '/api/v1/participants' do
    post('Join activity') do
      tags 'Participants'
      consumes 'application/json'
      produces 'application/json'

      request_body do
        content 'application/json' => {
          schema: {
            type: :object,
            properties: {
              user_id: { type: :integer, example: 5 },
              activity_id: { type: :integer, example: 1 }
            },
            required: %w[user_id activity_id]
          }
        }
      end

      response(201, 'created') do
        schema type: :object,
               properties: {
                  id: { type: :integer, example: 10 },
                  user_id: { type: :integer, example: 5 },
                  activity_id: { type: :integer, example: 1 },
                  created_at: { type: :string, format: 'date-time', example: '2028-03-24T14:15:22Z' }
               }

        let(:valid_params) { { user_id: 5, activity_id: 1 } }
        run_test!
      end
    end
  end
end
