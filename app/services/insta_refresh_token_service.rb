class InstaRefreshTokenService
  # https://developers.facebook.com/docs/instagram-basic-display-api/guides/long-lived-access-tokens
  def call(access_token)
    # access_token = InstaAccessToken.last.access_token
    response = Faraday.get("https://graph.instagram.com/refresh_access_token") do |req|
      req.headers = headers,
                    req.params = params(access_token)
    end
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