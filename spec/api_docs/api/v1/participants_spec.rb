require 'swagger_helper'

RSpec.describe 'Participants API V1', type: :request do

  path '/api/v1/participants' do

    post('Join activity') do
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
  end
end
