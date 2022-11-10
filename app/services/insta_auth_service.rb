# code = 'AQCasuw'
# redirect_uri = 'https://insta2blog.com/instagram/callback'
# insta_user_id = InstaAuthService.new(code, redirect_uri).call
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
    long_lived_access_token = ask_long_lived_access_token(short_lived_access_token)
    insta_access_token = InstaAccessToken.create(long_lived_access_token)
    insta_user = InstaMeService.new(insta_access_token.access_token).call
    insta_user.insta_access_tokens.delete_all
    insta_access_token.update(insta_user_id: insta_user.id)
    # schedule job to create insta_user_media
    # InstaMediaService.new(long_lived_access_token).call
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
    data.except('token_type')
  end

  def long_lived_access_token_params(short_lived_access_token)
    {
      grant_type: 'ig_exchange_token',
      client_secret: CLIENT_SECRET,
      access_token: short_lived_access_token
    }
  end
end
