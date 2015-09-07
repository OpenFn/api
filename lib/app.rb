require "roda"
require "rack/protection"
require "json"
require "sequel"

DB = Sequel.connect('postgres://stuart@localhost/uadt_test?search_path=1')

class App < Roda
  use Rack::Session::Cookie, :secret => (ENV['SECRET'] || 'supersecret')
  use Rack::Protection

  route do |r|
    # GET / request
    r.root do
      r.redirect "/hello"
    end

    r.on "mappings" do
      r.get do
        response['Content-Type'] = 'application/json'
        {'a'=>'b'}.to_json
      end

      r.post do
        mapping = JSON.parse(request.body.read)
        id = DB.from(:mappings).insert(mapping)

        response[ 'Content-Type' ] = "application/json"
        response[ 'Location' ] = (Pathname.new(request.base_url) + "mappings/#{id}").to_s
        response.status = 201
      end
    end

  end
end
