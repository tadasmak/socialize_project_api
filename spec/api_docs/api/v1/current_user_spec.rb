require 'swagger_helper'

RSpec.describe 'api/v1/current_user', type: :request do
  path '/api/v1/current_user' do
    get('Get currently logged in user data') do
      tags 'Session'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/User'
        run_test!
      end

      response(401, 'Unauthorized') { run_test! }
    end

    patch('Update currently logged in user data') do
      tags 'Session'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/User'
        run_test!
      end

      response(400, 'Bad Request - missing or invalid fields') { run_test! }

      response(401, 'Unauthorized') { run_test! }
    end

    delete('Delete currently logged in user data') do
      tags 'Session'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(204, 'No Content') { run_test! }

      response(401, 'Unauthorized') { run_test! }
    end
  end
end
