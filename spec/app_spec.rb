require 'app'

describe App do

  def app
    described_class
  end

  it "should get a list of mappings" do
    get '/mappings'
    expect(last_response.content_type).to eql "application/json"
  end

  it "should save a mapping" do
    post '/mappings', {title: "Hello"}.to_json
    expect(last_response.content_type).to eql "application/json"
    expect(last_response.status).to eql 201
    expect(last_response.location).to eql "http://example.org/mappings/17"
  end
end
