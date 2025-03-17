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

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/User'

        let(:user) { { email: 'user@example.com', username: 'john_doe', personality: 5 } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

    get('Show user') do
      tags 'Users'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/User'

        let(:id) { 123 }
        run_test!
      end
    end

    patch('Update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      parameter name: :user, in: :body, required: true, schema: {
        '$ref' => '#/components/schemas/UserUpdate'
      }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/User'

        let(:id) { 123 }
        let(:user_params) { { username: 'something_updated', personality: 2 } }

        run_test!
      end
    end

    delete('Delete user') do
      tags 'Users'

      security [ BearerAuth: [] ]

      response(204, 'no content') do
        let(:id) { 123 }
        run_test!
      end
    end
  end
end
