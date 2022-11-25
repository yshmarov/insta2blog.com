# Refresh expiring bearer token for accessing the API. 60 days valid.
# API reference:
# https://developers.facebook.com/docs/instagram-basic-display-api/guides/long-lived-access-tokens#long-lived-access-tokens

# insta_access_token_id = InstaAccessToken.last.id
# InstaRefreshTokenService.new(insta_access_token_id).call
class InstaRefreshTokenService
  attr_reader :insta_access_token, :insta_user

  def initialize(insta_access_token_id)
    @insta_access_token = InstaAccessToken.find(insta_access_token_id)
    @insta_user = insta_access_token.insta_user
  end

  def call
    response = Faraday.get('https://graph.instagram.com/refresh_access_token') do |req|
      req.headers = headers,
                    req.params = params(insta_access_token.access_token)
    end
    return unless response.status == 200

    data = JSON.parse(response.body)
    insta_access_token.update(access_token: data['access_token'],
                              expires_in: data['expires_in'],
                              expires_at: Time.zone.now + data['expires_in'])
  end

  private

  def headers
    { Accept: 'application/json' }
  end

  def params(access_token)
    {
      grant_type: 'ig_refresh_token',
      access_token:
    }
  end
end
