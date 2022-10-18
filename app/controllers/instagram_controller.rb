class InstagramController < ApplicationController
  CLIENT_ID = Rails.application.credentials.dig(:instagram, :client_id).to_s
  CLIENT_SECRET = Rails.application.credentials.dig(:instagram, :client_secret).to_s

  def authorize
    # Link to log in with instagram.
    authorize_url = 'https://api.instagram.com/oauth/authorize'
    redirect_to "#{authorize_url}?client_id=#{CLIENT_ID}&redirect_uri=#{instagram_callback_url}&scope=user_profile,user_media&response_type=code",
                allow_other_host: true
  end

  # GET /instagram/callback/?code=
  def callback
    # Log in with instagram -> get authorization code via redirect callback.
    code = params[:code]
    return head :bad_request unless code

    # Exchange authorization code for short lived access token (1 hour).
    response = Faraday.post('https://api.instagram.com/oauth/access_token') do |req|
      req.headers = headers,
                    req.body = authorization_params(code)
    end

    data = JSON.parse(response.body)
    # {"access_token"=>"IGQVJVWE", "user_id"=>17841404031032010}

    access_token = data['access_token']

    # Exchange short lived access token for long lived access token (60 days).
    if access_token
      res = Faraday.get("#{graph_base_url}/access_token") do |req|
        req.headers = headers,
                      req.params = long_lived_access_token_params(access_token)
      end

      long_lived_data = JSON.parse(res.body)
      # {"access_token"=>"IGQVJ", "token_type"=>"bearer", "expires_in"=>5115900}

      long_lived_access_token = long_lived_data['access_token']

      if long_lived_access_token
        # https://binarysolo.chapter24.blog/demystifying-cookies-in-rails-6/
        # session[:s_token] = long_lived_access_token
        # cookies.signed[:s_token] = long_lived_access_token
        # cookies.encrypted[:e_token] = long_lived_access_token
        cookies[:c_token] = long_lived_access_token
        InstaAccessToken.create(
          access_token: long_lived_access_token,
          expires_in: long_lived_data['expires_in']
        )
        render json: { message: 'ok' }, status: :ok
        # redirect_to me_path
      else
        render json: { error: res.body.to_s }, status: res.status
      end
    else
      render json: { error: response.body.to_s }, status: response.status
    end
  end

  def me
    insta_access_token = InstaAccessToken.find_by(access_token: cookies[:c_token])
    # get user data
    response = Faraday.get("#{graph_base_url}/me") do |req|
      req.headers = headers,
                    req.params = user_params(insta_access_token.access_token)
    end

    # generate user from data
    data = JSON.parse(response.body)
    @insta_user = InstaUser.find_or_create_by(
      remote_id: data['id'],
      username: data['username'],
      account_type: data['account_type'],
      media_count: data['media_count']
    )

    respond_to do |format|
      format.json { render json: response.body }
      format.html do
        # @insta_user
      end
    end
  end

  def media
    insta_access_token = InstaAccessToken.find_by(access_token: cookies[:c_token])
    response = Faraday.get("#{graph_base_url}/me/media") do |req|
      req.headers = headers,
                    req.params = media_params(insta_access_token.access_token)
    end

    # InstaUser.find_by()
    # JSON.parse(response.body)['data'].each do |record|
    # end

    respond_to do |format|
      format.json { render json: response.body }
      format.html do
        @records = JSON.parse(response.body)['data']
      end
    end
  end

  private

  def headers
    { Accept: 'application/json' }
  end

  def graph_base_url
    'https://graph.instagram.com'
  end

  def authorization_params(code)
    {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code:,
      grant_type: 'authorization_code',
      redirect_uri: instagram_callback_url
    }
  end

  def long_lived_access_token_params(access_token)
    {
      grant_type: 'ig_exchange_token',
      client_secret: CLIENT_SECRET,
      access_token:
    }
  end

  def user_params(access_token)
    {
      fields: 'id,username,account_type,media_count',
      access_token:
    }
  end

  def media_params(access_token)
    {
      fields: 'id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username',
      access_token:
    }
  end
end
