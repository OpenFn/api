require 'app'

describe App do

  def app
    described_class
  end

  context '/mappings' do
    it "should get a list of mappings" do
      expect(Mappings).to receive(:all).and_return([])
      get '/mappings'
      expect(last_response.content_type).to eql "application/json"
    end

    it "should save a mapping" do
      expect(Mappings).to receive(:insert).and_return(17)
      post '/mappings', {title: "Hello"}.to_json
      expect(last_response.content_type).to eql "application/json"
      expect(last_response.status).to eql 201
      expect(last_response.location).to eql "http://example.org/mappings/17"
    end

    context '/submissions' do
      it "should get a list of submissions" do
        expect(Submissions).to receive(:all).and_return([])
        get '/mappings/10/submissions'
        expect(last_response.content_type).to eql "application/json"
        expect(last_response.status).to eql 200
      end
      
      it 'should create a new submission' do
        expect(Submissions).to receive(:insert).with({:mapping => 10, "body" => "{}"}).
          and_return(21)
        post '/mappings/10/submissions', {body: "{}"}.to_json
        
        expect(last_response.content_type).to eql "application/json"
        expect(last_response.status).to eql 201
        expect(last_response.location).to eql "http://example.org/submissions/21"
      end
    end
  end

end
