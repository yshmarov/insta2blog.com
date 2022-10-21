# can I still use previous token to make an API call?
# https://developers.facebook.com/docs/instagram-basic-display-api/guides/long-lived-access-tokens#long-lived-access-tokens

# insta_access_token = InstaAccessToken.last
# new_long_lived_access_token = InstaRefreshTokenService.new(insta_access_token).call
class InstaRefreshTokenService
  attr_reader :insta_access_token, :insta_user

  def initialize(insta_access_token)
    @insta_access_token = insta_access_token
    @insta_user = insta_access_token.insta_user
  end

  def call
    # get a new token
    response = Faraday.get('https://graph.instagram.com/refresh_access_token') do |req|
      req.headers = headers,
                    req.params = params(insta_access_token.access_token)
    end
    # {"access_token"=> "UXE5RDNR", "token_type"=>"bearer", "expires_in"=>5143192}
    data = JSON.parse(response.body)
    # if success
    #   new_insta_access_token = InstaAccessToken.create(data.except('token_type'))
    #   new_insta_access_token.update(insta_user_id: insta_user.id)
    #   insta_access_token.update(valid: false)
    #   insta_access_token.destroy
    # end
  end

  private

  def check_current_token
  end

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
