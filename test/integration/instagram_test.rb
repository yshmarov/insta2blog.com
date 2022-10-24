require 'test_helper'

class InstagramTest < ActionDispatch::IntegrationTest
  test 'authorize' do
    get instagram_authorize_url
    assert_response :redirect
  end

  test 'callback' do
    skip # will stub faraday requests later
    status = 200
    headers = { Accept: 'application/json' }

    short_token_url = 'https://api.instagram.com/oauth/access_token'
    short_token_body = { 'access_token' => 'IGQVJVWE', 'user_id' => 17841404031032010 }

    long_token_url = 'https://graph.instagram.com/access_token'
    long_token_body = { 'access_token' => 'IGQVJ', 'token_type' => 'bearer', 'expires_in' => 5115900 }

    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post(short_token_url) do |_env|
          [status, headers, short_token_body]
        end
        stub.get(long_token_url) do |_env|
          [status, headers, long_token_body]
        end
        stub.get('/boom') do
          raise Faraday::ConnectionFailed
        end
      end
    end

    # stubs = Faraday::Adapter::Test::Stubs.new do |stub|
    #   stub.post(short_token_url) { |env| [ status, headers, short_token_body ]}
    #   stub.post(long_token_url) { |env| [ status, headers, long_token_body ]}
    #   stub.get('/tamago') { |env| [200, {}, 'egg'] }
    # end
    # conn = Faraday.new do |builder|
    #   builder.adapter :test, stubs do |stub|
    #     stub.post(short_token_url) { |env| [ status, headers, short_token_body ]}
    #     stub.post(long_token_url) { |env| [ status, headers, long_token_body ]}
    #   end
    # end

    get instagram_callback_url(code: 'abc')
    assert_response :success
  end
end
