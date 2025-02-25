require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post('Create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :email, in: :body, required: true, schema: { type: :string, format: :email, example: 'user@example.com' }
      parameter name: :username, in: :body, required: true, schema: { type: :string, minLength: 3, maxLength: 16, example: 'john_doe' }
      parameter name: :personality, in: :body, required: true, schema: { type: :integer, minimum: 1, maximum: 7, example: 5 }

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

      parameter name: :username, in: :body, schema: { type: :string, minLength: 3, maxLength: 16, example: 'new_username' }
      parameter name: :personality, in: :body, schema: { type: :integer, minimum: 3, maximum: 16, example: 2 }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/User'

        let(:id) { 123 }
        let(:user_params) { { username: 'something_updated', personality: 2 } }

        run_test!
      end
    end

    delete('Delete user') do
      tags 'Users'

      response(204, 'no content') do
        let(:id) { 123 }
        run_test!
      end
    end
  end
end
