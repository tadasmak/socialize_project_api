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
              user: { '$ref' => '#/components/schemas/User' },
              participants: {
                type: :array,
                items: { '$ref' => '#/components/schemas/User' }
              }
            }
          },
          Participant: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              user_id: { type: :integer, example: 2 },
              activity_id: { type: :integer, example: 15 },
              created_at: { type: :string, format: 'date-time', example: '2024-02-24T14:15:22Z' }
            }
          },
          User: {
            type: :object,
            properties: {
              id: { type: :integer, example: 14 },
              email: { type: :string, example: 'user@example.com' },
              username: { type: :string, example: 'john_doe' },
              personality: { type: :integer, example: 5 }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :json
end
