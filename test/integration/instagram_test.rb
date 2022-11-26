require 'test_helper'

# rubocop:disable Style/NumericLiterals, Layout/LineLength
class InstagramTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test 'authorize' do
    get instagram_authorize_url
    assert_response :redirect
  end

  test 'callback' do
    passwordless_sign_in(@user)

    stub_ask_short_lived_access_token
    stub_ask_long_lived_access_token
    stub_ask_user_profile

    get instagram_callback_url(code: 'callbackcode123')
    assert_response :redirect
    assert_redirected_to user_path

    follow_redirect!
    assert_response :success
    assert_match 'Connect an Instagram account', @response.body
    assert_match 'posts detected', @response.body
    assert_match 'yaro_the_slav', @response.body

    assert_equal @user.insta_users.count, 1

    insta_access_token = @user.insta_users.first.insta_access_tokens.first
    assert_equal insta_access_token.expires_at.round, (insta_access_token.created_at + insta_access_token.expires_in).round
  end

  private

  def stub_ask_short_lived_access_token
    short_token_url = 'https://api.instagram.com/oauth/access_token'
    short_token_body = { 'access_token' => 'UVWXYZ', 'user_id' => 123456 }
    stub_request(:post, short_token_url)
      .with(body: { 'client_id' => Rails.application.credentials.dig(:instagram, :client_id).to_s,
                    'client_secret' => Rails.application.credentials.dig(:instagram, :client_secret).to_s,
                    'code' => 'callbackcode123',
                    'grant_type' => 'authorization_code',
                    'redirect_uri' => 'https://insta2blog.com/' })
      .to_return(status: 200, body: short_token_body.to_json, headers: {})
  end

  def stub_ask_long_lived_access_token
    long_token_url = 'https://graph.instagram.com/access_token'
    long_token_body = { 'access_token' => 'ABCDE', 'token_type' => 'bearer', 'expires_in' => 5115900 }
    stub_request(:get, "#{long_token_url}?access_token=UVWXYZ&client_secret=#{Rails.application.credentials.dig(:instagram, :client_secret)}&grant_type=ig_exchange_token")
      .to_return(status: 300, body: long_token_body.to_json, headers: {})
  end

  def stub_ask_user_profile
    me_url = 'https://graph.instagram.com/me'
    me_body = { 'id' => '12345', 'username' => 'yaro_the_slav', 'account_type' => 'PERSONAL', 'media_count' => 305 }
    stub_request(:get, "#{me_url}?access_token=ABCDE&fields=id,username,account_type,media_count")
      .to_return(status: 200, body: me_body.to_json, headers: {})
  end
end
# rubocop:enable Style/NumericLiterals, Layout/LineLength
