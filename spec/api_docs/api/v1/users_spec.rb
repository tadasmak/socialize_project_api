require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post('Create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      request_body do
        content 'application/json' => {
          schema: {
            type: :object,
            properties: {
              email: { type: :string, format: :email, example: 'user@example.com' },
              username: { type: :string, minLength: 3, maxLength: 16, example: 'john_doe' },
              personality: { type: :integer, minimum: 1, maximum: 7, example: 5 }
            },
            required: %w[email username personality]
          }
        }
      end

      response(201, 'created') do
        let(:user) { { email: 'user@example.com', username: 'john_doe', personality: 5 } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string, required: true, description: 'User ID'

    get('Show user') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                  id: { type: :integer, example: 123 },
                  email: { type: :string, example: 'user@example.com' },
                  username: { type: :string, example: 'john_doe' },
                  personality: { type: :integer, example: 5 }
               }

        let(:id) { 123 }
        run_test!
      end
    end

    patch('Update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      request_body do
        content 'application/json' => {
          schema: {
            type: :object,
            properties: {
              username: { type: :string, minLength: 3, maxLength: 16, example: 'new_username' },
              personality: { type: :integer, minimum: 1, maximum: 7, example: 3 }
            }
          }
        }
      end

      response(200, 'successful') do
        let(:id) { 123 }
        run_test!
      end
    end

    delete('Delete user') do
      tags 'Users'

      response(204, 'no content') do
        let(:id) { '123' }
        run_test!
      end
    end
  end
end
