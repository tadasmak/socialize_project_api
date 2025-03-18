require 'swagger_helper'

RSpec.describe '/api/v1/activities', type: :request do
  path '/api/v1/activities' do
    get('List activities') do
      tags 'Activities'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Activity' }

        run_test!
      end
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

        let(:activity) { { title: 'Soccer game', description: 'A soccer game for beginners', location: 'Barcelona Stadium', start_time: '2028-03-24T14:15:22Z', max_participants: 5, user_id: 2 } }
        run_test!
      end

      response(400, 'Bad Request - missing or invalid fields') { run_test! }
    end
  end

  path '/api/v1/activities/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Activity ID'

    get('Show activity') do
      tags 'Activities'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'Successful') do
        schema '$ref' => '#/components/schemas/Activity'

        let(:id) { 123 }
        run_test!
      end
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

        let(:id) { 123 }
        let(:activity_params) { { title: 'Updated activity', description: 'Updated activity description', location: 'Different activity location', start_time: '2026-06-26T14:15:22Z', max_participants: 7 } }

        run_test!
      end

      response(400, 'Bad Request - missing or invalid fields') { run_test! }

      response(403, 'You are not authorized to execute this action') do
        let(:id) { 123 }
        run_test!
      end
    end

    delete('Delete activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(204, 'No Content') do
        let(:id) { 123 }
        run_test!
      end

      response(403, 'You are not authorized to execute this action') do
        let(:id) { 123 }
        run_test!
      end
    end
  end

  path '/api/v1/activities/{id}/join' do
    parameter name: 'id', in: :path, type: :integer, description: 'Activity ID'

    post('Join activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(201, 'User joined the activity') do
        let(:id) { 123 }
        run_test!
      end

      response(409, 'User already participates in this activity') do
        let(:id) { 123 }
        run_test!
      end

      response(422, 'User could not join the activity due to validation errors') do
        let(:id) { 123 }
        run_test!
      end
    end
  end

  path '/api/v1/activities/{id}/leave' do
    parameter name: 'id', in: :path, type: :integer, description: 'Activity ID'

    delete('Leave activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(200, 'User left the activity') do
        let(:id) { 123 }
        run_test!
      end

      response(409, 'User cannot leave their own activity') do
        let(:id) { 123 }
        run_test!
      end

      response(422, 'User is not a part of this activity') do
        let(:id) { 123 }
        run_test!
      end
    end
  end
end
