require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'bundle/'
  add_filter 'spec/'
  add_filter 'vendor/'
end

require 'webmock/rspec'

require_relative '../lib/vcloud'

RSpec.configure do |config|
  config.before(:each) {
    stub_request(:post, 'https://someuser%40someorg:password@some.vcloud.com/api/sessions').
      with(:headers => {'Accept'=>'application/*+xml;version=1.5'}).
      to_return(:status => 200, :body => fixture_file('session.xml'), :headers => {:x_vcloud_authorization => 'abc123xyz'})

    @session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')
    @session.login('someuser@someorg', 'password')

    WebMock.reset!
  }
end

def fixture_file(filename)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
end
