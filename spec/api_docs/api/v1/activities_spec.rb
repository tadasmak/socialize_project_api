require 'swagger_helper'

RSpec.describe 'Activities API V1', type: :request do
  path '/api/v1/activities' do
    get('List activities') do
      tags 'Activities'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('Create activity') do
      tags 'Activities'
      parameter name: 'title', in: :body, type: :string, required: true, description: "Consists of 8-100 symbols without any special characters"
      parameter name: 'description', in: :body, type: :text, required: true, description: "Consists of 40-1000 symbols without any special characters"
      parameter name: 'location', in: :body, type: :string, required: true, description: "Consists of 4-100 symbols without any special characters"
      parameter name: 'start_time', in: :body, type: :string, required: true, description: "Must be in datetime format and no further than 1 month in the future"
      parameter name: 'max_participants', in: :body, type: :integer, required: true, description: "Accepts from 2 to 8"
      parameter name: 'user_id', in: :body, type: :integer, required: true, description: "Activity owner's user id"

      response(201, 'created') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/activities/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Show activity') do
      tags 'Activities'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('Update activity') do
      tags 'Activities'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('Update activity') do
      tags 'Activities'
      parameter name: 'title', in: :body, type: :string, description: "Consists of 8-100 symbols without any special characters"
      parameter name: 'description', in: :body, type: :text, description: "Consists of 40-1000 symbols without any special characters"
      parameter name: 'location', in: :body, type: :string, description: "Consists of 4-100 symbols without any special characters"
      parameter name: 'start_time', in: :body, type: :string, description: "Must be in datetime format and no further than 1 month in the future"
      parameter name: 'max_participants', in: :body, type: :integer, description: "Accepts from 2 to 8"

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('Delete activity') do
      tags 'Activities'
      response(204, 'no content') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
          }
        end
        run_test!
      end
    end
  end
end
