require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post('Create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      parameter name: :user, in: :body, required: true, schema: {
        '$ref' => '#/components/schemas/UserRequest'
      }

      response(201, 'Created') do
        schema '$ref' => '#/components/schemas/User'
        run_test!
      end

      response(400, 'Bad Request - missing or invalid fields') { run_test! }
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

    get('Show user') do
      tags 'Users'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/User'
        run_test!
      end

      response(404, 'Not Found') { run_test! }
    end
  end
end
