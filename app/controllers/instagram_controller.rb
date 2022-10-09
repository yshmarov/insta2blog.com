class InstagramController < ApplicationController
  CLIENT_ID = Rails.application.credentials.dig(:instagram, :client_id).to_s
  CLIENT_SECRET = Rails.application.credentials.dig(:instagram, :client_secret).to_s

  # CLIENT_ID = ENV.fetch('INSTAGRAM_CLIENT_ID', nil)
  # CLIENT_SECRET = ENV.fetch('INSTAGRAM_CLIENT_SECRET', nil)
  REDIRECT_URI = ENV.fetch('INSTAGRAM_REDIRECT_URI', nil)
  # REDIRECT_URI = url_for(instagram_callback_path, base_url: true)

  # Rails.application.routes.url_helpers.url_for(callback_path, only_path: false)
  # include Rails.application.routes.url_helpers
  # url_for(controller: 'instagram',
  # 	host: '',
  # 	action: 'callback',
  # 	protocol: 'https',
  # 	only_path: false)

  # https://www.instagram.com/accounts/manage_access/
  # https://insta2site.herokuapp.com/?code=abc

  def authorize
    authorize_url = 'https://api.instagram.com/oauth/authorize'
    redirect_to "#{authorize_url}?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&scope=user_profile,user_media&response_type=code",
                allow_other_host: true
  end

  def media
    access_token = InstagramAccessToken.last.access_token
    response = Faraday.get("#{graph_base_url}/me/media") do |req|
      req.headers = headers,
                    req.params = media_params(access_token)
    end

    render json: response.body
  end

  def callback
    code = params[:code]
    return head :bad_request unless code

    get_access_token_url = 'https://api.instagram.com/oauth/access_token'
    response = Faraday.post(get_access_token_url) do |req|
      req.headers = headers,
                    req.body = authorization_params(code)
    end

    data = JSON.parse(response.body)

    access_token = data['access_token']

    if access_token
      res = Faraday.get(get_long_lived_access_token_url) do |req|
        req.headers = headers,
                      req.params = long_lived_access_token_params(access_token)
      end

      long_lived_data = JSON.parse(response.body)

      long_lived_access_token = long_lived_data['access_token']

      if long_lived_access_token
        InstagramAccessToken.create(
          access_token: long_lived_access_token
        )
        render json: { message: 'ok' }, status: :ok
      else
        render json: { error: "#{res.body}" }, status: res.status
      end
    else
      render json: { error: "#{response.body}" }, status: response.status
    end
  end

  def me
    access_token = InstagramAccessToken.last.access_token
    user_params = { fields: 'id,username,account_type,media_count', access_token: }
    response = Faraday.get("#{graph_base_url}/me") do |req|
      req.headers = headers, req.params = user_params
    end
    render json: response.body
  end

  private

  def authorization_params(code)
    {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code:,
      grant_type: 'authorization_code',
      redirect_uri: REDIRECT_URI
    }
  end

  def graph_base_url
    'https://graph.instagram.com'
  end

  def headers
    { Accept: 'application/json' }
  end

  def get_long_lived_access_token_url
    'https://graph.instagram.com/access_token'
  end

  def long_lived_access_token_params(access_token)
    {
      grant_type: 'ig_exchange_token',
      client_secret: CLIENT_SECRET,
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
