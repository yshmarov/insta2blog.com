# InstaAuthService.new('AQCasuw', 'https://insta2blog.com/instagram/callback').call
class InstaAuthService
  CLIENT_ID = Rails.application.credentials.dig(:instagram, :client_id).to_s
  CLIENT_SECRET = Rails.application.credentials.dig(:instagram, :client_secret).to_s

  attr_reader :code, :redirect_uri

  def initialize(code, redirect_uri)
    @code = code
    @redirect_uri = redirect_uri
  end

  def call
    short_lived_access_token = ask_short_lived_access_token(code)
    # return ? unless short_lived_access_token
    long_lived_access_token = ask_long_lived_access_token(short_lived_access_token)
    insta_access_token = InstaAccessToken.create(long_lived_access_token)
    insta_user_data = ask_user_profile(insta_access_token)
    insta_user = InstaUser.find_or_create_by(remote_id: insta_user_data['id'])
    insta_user.update(
      username: insta_user_data['username'],
      account_type: insta_user_data['account_type'],
      media_count: insta_user_data['media_count']
    )
    # will the long token id be replaced?
    # associate insta_access_token with insta_user
    # schedule job to create insta_user_media
    insta_user.id
  end

  private

  def headers
    { Accept: 'application/json' }
  end

  def ask_short_lived_access_token(code)
    response = Faraday.post('https://api.instagram.com/oauth/access_token') do |request|
      request.headers = headers,
                        request.body = short_lived_access_token_params(code)
    end
    data = JSON.parse(response.body)
    # {"access_token"=>"IGQVJVWE", "user_id"=>17841404031032010}
    data['access_token']
  end

  def short_lived_access_token_params(code)
    {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code:,
      grant_type: 'authorization_code',
      redirect_uri:
    }
  end

  def ask_long_lived_access_token(short_lived_access_token)
    response = Faraday.get('https://graph.instagram.com/access_token') do |request|
      request.headers = headers,
                        request.params = long_lived_access_token_params(short_lived_access_token)
    end
    data = JSON.parse(response.body)
    # {"access_token"=>"IGQVJ", "token_type"=>"bearer", "expires_in"=>5115900}
    # data['access_token']
    data.except('token_type')
  end

  def long_lived_access_token_params(short_lived_access_token)
    {
      grant_type: 'ig_exchange_token',
      client_secret: CLIENT_SECRET,
      access_token: short_lived_access_token
    }
  end

  def ask_user_profile(insta_access_token)
    response = Faraday.get('https://graph.instagram.com/me') do |req|
      req.headers = headers,
                    req.params = user_params(insta_access_token.access_token)
    end
    JSON.parse(response.body)
    # {"id"=>"5973192396032263", "username"=>"yaro_the_slav", "account_type"=>"PERSONAL", "media_count"=>305}
  end

  def user_params(access_token)
    {
      fields: 'id,username,account_type,media_count',
      access_token:
    }
  end
end
