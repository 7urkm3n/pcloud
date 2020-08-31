describe Pcloud do
  [lambda { Pcloud }, lambda { Pcloud::Client.new }].each do |client_gen|
    before :each do
      @client = client_gen.call
    end

    describe 'default configuration' do
      it 'should be preconfigured for api host' do
        expect(@client.host).to eq('api.pusherapp.com')
      end

      it 'should be preconfigured for port 80' do
        expect(@client.port).to eq(80)
      end

      it 'should use standard logger if no other logger if defined' do
        Pusher.logger.debug('foo')
        expect(Pusher.logger).to be_kind_of(Logger)
      end
    end

    describe 'logging configuration' do
      it "can be configured to use any logger" do
        logger = double("ALogger")
        expect(logger).to receive(:debug).with('foo')
        Pusher.logger = logger
        Pusher.logger.debug('foo')
        Pusher.logger = nil
      end
    end

    describe "configuration using url" do
      it "should be possible to configure everything by setting the url" do
        @client.url = "test://somekey:somesecret@api.staging.pusherapp.com:8080/apps/87"

        expect(@client.scheme).to eq('test')
        expect(@client.host).to eq('api.staging.pusherapp.com')
        expect(@client.port).to eq(8080)
        expect(@client.key).to eq('somekey')
        expect(@client.secret).to eq('somesecret')
        expect(@client.app_id).to eq('87')
      end



      it "should fail on bad urls" do
        expect { @client.url = "gopher/somekey:somesecret@://api.staging.pusherapp.co://m:8080\apps\87" }.to raise_error(URI::InvalidURIError)
      end

      it "should raise exception if app_id is not configured" do
        @client.app_id = nil
        expect {
          @client.url
        }.to raise_error(Pusher::ConfigurationError)
      end
    end
  end
end
