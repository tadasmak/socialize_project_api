require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  path 'api/v1/users/sign_in' do
    post('Sign in with user credentials') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      parameter name: :credentials, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                message: { type: :string, example: 'Logged in successfully' },
                user: { '$ref' => '#/components/schemas/User' }
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :string, example: 'Invalid Email or password'
        run_test!
      end
    end
  end
end
