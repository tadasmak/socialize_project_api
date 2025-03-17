require 'swagger_helper'

RSpec.describe '/api/v1/activities', type: :request do
  path '/api/v1/activities' do
    get('List activities') do
      tags 'Activities'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'successful') do
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

      response(201, 'created') do
        schema '$ref' => '#/components/schemas/Activity'

        let(:activity) { { title: 'Soccer game', description: 'A soccer game for beginners', location: 'Barcelona Stadium', start_time: '2028-03-24T14:15:22Z', max_participants: 5, user_id: 2 } }
        run_test!
      end
    end
  end

  path '/api/v1/activities/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Activity ID'

    get('Show activity') do
      tags 'Activities'
      produces 'application/json'

      security [ BearerAuth: [] ]

      response(200, 'successful') do
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

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/Activity'

        let(:id) { 123 }
        let(:activity_params) { { title: 'Updated activity', description: 'Updated activity description', location: 'Different activity location', start_time: '2026-06-26T14:15:22Z', max_participants: 7 } }

        run_test!
      end
    end

    delete('Delete activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(204, 'no content') do
        let(:id) { 123 }
        run_test!
      end
    end
  end

  path '/api/v1/activites/{id}/join' do
    post('Join activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(201, 'user successfully joined activity') do
        let(:id) { 123 }
        run_test!
      end

      response(409, 'user already participates in this activity') do
        let(:id) { 123 }
        run_test!
      end

      response(422, 'user cannot join the activity') do
        let(:id) { 123 }
        run_test!
      end
    end
  end

  path '/api/v1/activites/{id}/leave' do
    delete('Leave activity') do
      tags 'Activities'

      security [ BearerAuth: [] ]

      response(200, 'user successfully left activity') do
        let(:id) { 123 }
        run_test!
      end

      response(422, 'user is not a part of the activity') do
        let(:id) { 123 }
        run_test!
      end
    end
  end
end
