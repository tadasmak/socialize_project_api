require 'swagger_helper'

RSpec.describe '/api/v1/activities', type: :request do
  path '/api/v1/activities' do
    get('List activities') do
      tags 'Activities'
      produces 'application/json'

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

      parameter name: :title, in: :body, required: true, schema: {
        type: :string,
        minLength: 8,
        maxLength: 100,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'Soccer Game',
        description: 'Title must be 8-100 characters long and cannot contain special characters <>{}[]|\\^~'
      }
      parameter name: :description, in: :body, required: true, schema: {
        type: :string,
        minLength: 40,
        maxLength: 1000,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'A soccer game for beginners',
        description: 'Description must be 40-1000 characters long and cannot contain special characters <>{}[]|\\^~'
      }
      parameter name: :location, in: :body, required: true, schema: {
        type: :string,
        minLength: 4,
        maxLength: 100,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'Barcelona Stadium',
        description: 'Location must be 4-100 characters long and cannot contain special characters <>{}[]|\\^~'
      }
      parameter name: :start_time, in: :body, required: true, schema: {
        type: :string,
        format: 'date-time',
        example: '2028-03-24T14:15:22Z',
        description: 'Start time of the activity (ISO 8601 format). Should be no further than 1 month in the future'
      }
      parameter name: :max_participants, in: :body, required: true, schema: {
        type: :integer,
        example: 5,
        minimum: 2,
        maximum: 8,
        description: 'Number of maximum participants, must be between 2 and 8.'
      }
      parameter name: :user_id, in: :body, required: true, schema: {
        type: :integer,
        example: 2,
        description: "Activity creator user's ID"
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

      parameter name: :title, in: :body, schema: {
        type: :string,
        minLength: 8,
        maxLength: 100,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'Soccer Game',
        description: 'Title must be 8-100 characters long and cannot contain special characters <>{}[]|\\^~'
      }
      parameter name: :description, in: :body, schema: {
        type: :string,
        minLength: 40,
        maxLength: 1000,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'A soccer game for beginners',
        description: 'Description must be 40-1000 characters long and must contain at least one special character <>{}[]|\\^~'
      }
      parameter name: :location, in: :body, schema: {
        type: :string,
        minLength: 4,
        maxLength: 100,
        pattern: '^[^<>{}\[\]|\\^~]+$',
        example: 'Barcelona Stadium',
        description: 'Location must be 4-100 characters long and must contain at least one special character <>{}[]|\\^~'
      }
      parameter name: :start_time, in: :body, schema: {
        type: :string,
        format: 'date-time',
        example: '2028-03-24T14:15:22Z',
        description: 'Start time of the activity (ISO 8601 format). Should be no further than 1 month in the future'
      }
      parameter name: :max_participants, in: :body, schema: {
        type: :integer,
        example: 5,
        minimum: 2,
        maximum: 8,
        description: 'Number of maximum participants, must be between 2 and 8.'
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
      response(204, 'no content') do
        let(:id) { 123 }
        run_test!
      end
    end
  end
end
