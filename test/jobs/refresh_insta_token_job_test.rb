require 'test_helper'

class RefreshInstaTokenJobTest < ActiveJob::TestCase
  def setup
    @insta_access_token = insta_access_tokens(:one)
  end

  test 'updates token expiration after successful request' do
    insta_access_token_id = @insta_access_token.id

    stub_request(:get, "https://graph.instagram.com/refresh_access_token?access_token=#{@insta_access_token.access_token}&grant_type=ig_refresh_token")
      .to_return(status: 200, body: response_body.to_json)

    assert @insta_access_token.expires_at < 10.days.from_now
    InstaRefreshTokenService.new(insta_access_token_id).call
    @insta_access_token.reload
    assert @insta_access_token.expires_at > 30.days.from_now
  end

  private

  def response_body
    { 'access_token' => 'UXE5RDNR', 'token_type' => 'bearer', 'expires_in' => 5_143_192 }
  end
end
