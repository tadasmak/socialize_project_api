# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      servers: [
        {
          url: "#{ENV.fetch('SERVER_URL', 'http://localhost:3000')}",
          variables: {}
        }
      ],
      paths: {},
      components: {
        securitySchemes: {
          BearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT Authorization header using the Bearer scheme. Example: "Authorization: Bearer <JWT_TOKEN>"'
          }
        },
        schemas: {
          Activity: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Basketball Game' },
              description: { type: :string, example: 'A 5v5 basketball game for beginners' },
              location: { type: :string, example: 'Crypto.com arena, Los Angeles' },
              start_time: { type: :string, format: 'date-time', example: '2028-03-24T14:15:22Z' },
              max_participants: { type: :integer, example: 5 },
              minimum_age: { type: :integer, example: 18 },
              maximum_age: { type: :integer, example: 25 },
              user: { '$ref' => '#/components/schemas/User' },
              participants: {
                type: :array,
                items: { '$ref' => '#/components/schemas/User' }
              }
            }
          },
          ActivityCreate: {
            type: :object,
            properties: {
              title: { type: :string, minLength: 8, maxLength: 100, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'Soccer Game', description: 'Title must be 8-100 characters long and cannot contain special characters <>{}[]|\\^~' },
              description: { type: :string, minLength: 40, maxLength: 1000, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'A soccer game for beginners', description: 'Description must be 40-1000 characters long and cannot contain special characters <>{}[]|\\^~' },
              location: { type: :string, minLength: 4, maxLength: 100, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'Barcelona Stadium', description: 'Location must be 4-100 characters long and cannot contain special characters <>{}[]|\\^~' },
              start_time: { type: :string, format: 'date-time', example: '2028-03-24T14:15:22Z', description: 'Start time of the activity (ISO 8601 format). Should be no further than 1 month in the future' },
              max_participants: { type: :integer, example: 5, minimum: 2, maximum: 8, description: 'Number of maximum participants, must be between 2 and 8.' },
              minimum_age: { type: :integer, example: 18, minimum: 18, maximum: 96, description: 'Minimum age of participants allowed' },
              maximum_age: { type: :integer, example: 25, minimum: 22, maximum: 100, description: 'Maximum age of participants allowed' },
              user_id: { type: :integer, example: 4, description: "Activity creator user's ID" }
            },
            required: %w[title description location start_time max_participants user_id]
          },
          ActivityUpdate: {
            type: :object,
            properties: {
              title: { type: :string, minLength: 8, maxLength: 100, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'Soccer Game', description: 'Title must be 8-100 characters long and cannot contain special characters <>{}[]|\\^~' },
              description: { type: :string, minLength: 40, maxLength: 1000, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'A soccer game for beginners', description: 'Description must be 40-1000 characters long and cannot contain special characters <>{}[]|\\^~' },
              location: { type: :string, minLength: 4, maxLength: 100, pattern: '^[^<>{}\[\]|\\^~]+$', example: 'Barcelona Stadium', description: 'Location must be 4-100 characters long and cannot contain special characters <>{}[]|\\^~' },
              start_time: { type: :string, format: 'date-time', example: '2028-03-24T14:15:22Z', description: 'Start time of the activity (ISO 8601 format). Should be no further than 1 month in the future' },
              max_participants: { type: :integer, example: 5, minimum: 2, maximum: 8, description: 'Number of maximum participants, must be between 2 and 8.' },
              minimum_age: { type: :integer, example: 18, minimum: 18, maximum: 96, description: 'Minimum age of participants allowed' },
              maximum_age: { type: :integer, example: 25, minimum: 22, maximum: 100, description: 'Maximum age of participants allowed' }
            }
          },
          User: {
            type: :object,
            properties: {
              id: { type: :integer, example: 14 },
              email: { type: :string, example: 'user@example.com' },
              username: { type: :string, example: 'john_doe' },
              personality: { type: :integer, example: 5 },
              birth_date: { type: :string, format: :date, example: '2000-01-01' }
            }
          },
          UserRequest: {
            type: :object,
            properties: {
              email: { type: :string, format: :email, example: 'user@example.com' },
              password: { type: :string, format: :password, example: 'password' }
            },
            required: %w[email password]
          },
          UserUpdate: {
            type: :object,
            properties: {
              username: { type: :string, format: :email, example: 'new_username' },
              personality: { type: :integer, minimum: 1, maximum: 7, example: 2 },
              birth_date: { type: :string, format: :date, example: '2000-01-01', description: 'Birth date can only be set once; cannot be changed. User must be between 18 and 100 years old.' }
            }
          }
        }
      },
      security: [ { BearerAuth: [] } ],
      tags: [
        { name: 'Authentication', description: 'Endpoints for user authentication' },
        { name: 'Session', description: 'Endpoints for managing the current user session' },
        { name: 'Activities', description: 'Endpoints for managing activities data' },
        { name: 'Users', description: 'Endpoints for managing users data' }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :json
end
