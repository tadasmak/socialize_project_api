require 'swagger_helper'

RSpec.describe '/api/v1/activities', type: :request do
  path '/api/v1/activities' do
    get('List activities') do
      tags 'Activities'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :limit, in: :query, type: :integer, description: 'Number of activities per page (1-10)'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Activity' }

        run_test!
      end

      response(422, 'Unprocessable Entity - invalid params provided') { run_test! }
    end

    post('Create activity') do
      tags 'Activities'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      parameter name: :activity, in: :body, required: true, schema: {
        '$ref' => '#/components/schemas/ActivityCreate'
      }

      response(201, 'Created') do
        schema '$ref' => '#/components/schemas/Activity'
        run_test!
      end

      response(422, 'Unprocessable Entity - missing or invalid fields') { run_test! }
    end
  end

  path '/api/v1/activities/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Activity ID'

    get('Show activity') do
      tags 'Activities'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/Activity'
        run_test!
      end

      response(404, 'Not Found') { run_test! }
    end

    patch('Update activity') do
      tags 'Activities'
      consumes 'application/json'
      produces 'application/json'

      security [ BearerAuth: [] ]

      parameter name: :activity, in: :body, schema: {
        '$ref' => '#/components/schemas/ActivityUpdate'
      }

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/Activity'
        run_test!
      end

      response(403, 'You are not authorized to execute this action') { run_test! }

      response(422, 'Unprocessable Entity - invalid fields') { run_test! }
    end

    delete('Delete activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(204, 'No Content') { run_test! }

      response(403, 'You are not authorized to execute this action') { run_test! }

      response(422, 'Unprocessable Entity - could not delete activity') { run_test! }
    end
  end

  path '/api/v1/activities/{id}/join' do
    parameter name: :id, in: :path, type: :integer, description: 'Activity ID'

    post('Join activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(201, 'User joined the activity') { run_test! }

      response(409, 'User already participates in this activity') { run_test! }

      response(422, 'Unprocessable Entity - user could not join the activity due to validation errors') { run_test! }
    end
  end

  path '/api/v1/activities/{id}/leave' do
    parameter name: :id, in: :path, type: :integer, description: 'Activity ID'

    delete('Leave activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(200, 'User left the activity') { run_test! }

      response(409, 'User cannot leave their own activity') { run_test! }

      response(422, 'Unprocessable Entity - user is not a part of this activity') { run_test! }
    end
  end
end
