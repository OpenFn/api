require 'app'

describe App do

  def app
    described_class
  end

  context '/mappings' do
    context 'GET' do

      it "should get a list of mappings" do
        expect(Mappings).to receive(:all).and_return([])
        get '/mappings'
        expect(last_response.content_type).to eql "application/json"
      end
      
    end

    context 'POST' do

      it "should save a mapping" do
        expect(Mappings).to receive(:insert).and_return(17)
        post '/mappings', {title: "Hello"}.to_json
        expect(last_response.content_type).to eql "application/json"
        expect(last_response.status).to eql 201
        expect(last_response.location).to eql "http://example.org/mappings/17"
      end
      
    end

    context '/:id' do
      context 'GET' do
        it "returns an existing mapping" do
          expect(Mappings).to receive(:find).
            with("10").and_return(double(Hash))

          get '/mappings/10'
          expect(last_response.content_type).to eql "application/json"
        end
        
        it "returns 404 when a mapping doesn't exist" do
          expect(Mappings).to receive(:find).
            with("10").and_return(nil)

          get '/mappings/10'
          expect(last_response.status).to eql 404
        end
      end

      context 'PUT' do
        it "updates the mapping"
      end
      
      context '/submissions' do
        before :each do
          expect(Mappings).to receive(:find).
            with("10").and_return({id: 10})
        end

        context 'GET' do
          it "returns a list of submissions" do
            expect(Submissions).to receive(:all).and_return([])
            get '/mappings/10/submissions'
            expect(last_response.content_type).to eql "application/json"
            expect(last_response.status).to eql 200
          end
        end

        context 'POST' do
          it 'creates a new submission' do
            expect(Submissions).to receive(:insert).with({
              :mapping => 10,
              "body" => "{}"
            }).and_return(21)

            post '/mappings/10/submissions', {body: "{}"}.to_json

            expect(last_response.content_type).to eql "application/json"
            expect(last_response.status).to eql 201
            expect(last_response.location).to eql "http://example.org/submissions/21"
          end
        end

      end

      context '/transform' do
        before :each do
          expect(Mappings).to receive(:find).
            with("10").and_return({id: 10})
        end

        context 'GET' do
          it "returns the mappings current transform" do
            expect(Transforms).to receive(:latest_for_mapping).with(10).
              and_return({})

            get '/mappings/10/transform'
            expect(last_response.content_type).to eql "application/json"
            expect(last_response.status).to eql 200

          end

          it "returns 404 when the mapping doesn't have a transform" do
            expect(Transforms).to receive(:latest_for_mapping).with(10).
              and_return(nil)

            get '/mappings/10/transform'
            expect(last_response.content_type).to eql "application/json"
            expect(last_response.status).to eql 404

          end
        end

        let(:transform) { { "spec" => {}.to_json, "mapping" => 10 } }
        context 'POST' do
          it "creates a transform assigned to the mapping" do
            expect(Transforms).to receive(:insert).with(transform).
              and_return(21)

            post '/mappings/10/transform', transform.to_json

            expect(last_response.content_type).to eql "application/json"
            expect(last_response.status).to eql 201
            expect(last_response.location).to eql "http://example.org/transforms/21"

          end
        end

        context 'PUT' do
          it "updates the current transform for this mapping"
        end

      end

    end

  end

end
