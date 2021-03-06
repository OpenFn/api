require "roda"
require "rack/protection"
require "json"
require "sequel"

DB = Sequel.connect('postgres://stuart@localhost/uadt_test?search_path=1')

require "repositories/mappings"
require "repositories/submissions"
require "repositories/transforms"

class App < Roda
  use Rack::Session::Cookie, :secret => (ENV['SECRET'] || 'supersecret')
  # use Rack::Protection

  route do |r|
    # GET / request
    r.root do
      r.redirect "/hello"
    end

    r.on "mappings" do

      response[ 'Access-Control-Allow-Origin' ] = "*"
      response[ 'Access-Control-Allow-Methods' ] = "GET, POST, OPTIONS"
      response[ 'Access-Control-Allow-Headers' ] = "Accept, Content-Type, Access-Control-Allow-Origin, Authorization, X-Requested-With, Location"
      response[ 'Access-Control-Max-Age' ] = "0"

      response[ 'Content-Type' ] = "application/json"

      r.on method: :options do
        response.status = 200
      end

      # /mappings/:id
      r.on :id do |id|
        @mapping = Mappings.find(id)

        # When the mapping exists
        r.on !!@mapping do

          # /mappings/:id/submissions
          r.on "submissions" do
            r.get do
              Submissions.all.to_json
            end

            r.post do
              submission = JSON.parse(request.body.read)
              submission.merge!({mapping: @mapping[:id]})
              id = Submissions.insert(submission)

              response[ 'Access-Control-Expose-Headers' ] = 'Location'
              response[ 'Location' ] = (Pathname.new(request.base_url) + "submissions/#{id}").to_s

              response.status = 201
            end
          end

          # /mappings/:id/transform
          r.on "transform" do
            r.get do
              transform = Transforms.latest_for_mapping(10)

              r.on !!transform do
                transform.to_json
              end
            end

            r.post do
              transform = JSON.parse(request.body.read)
              transform.merge!({"mapping" => @mapping[:id]})
              id = Transforms.insert(transform)

              response[ 'Access-Control-Expose-Headers' ] = 'Location'
              response[ 'Location' ] = (Pathname.new(request.base_url) + "transforms/#{id}").to_s

              response.status = 201
            end
          end

          # /mappings/:id
          r.get do
            @mapping.to_json
          end
        end
      end

      r.get do
        Mappings.all.to_json
      end

      r.post do
        response[ 'Access-Control-Expose-Headers' ] = 'Location'
        mapping = JSON.parse(request.body.read)
        id = Mappings.insert(mapping)

        response[ 'Location' ] = (Pathname.new(request.base_url) + "mappings/#{id}").to_s
        response.status = 201
      end
    end

  end
end
