class InstagramController < ApplicationController
  CLIENT_ID = Rails.application.credentials.dig(:instagram, :client_id).to_s
  CLIENT_SECRET = Rails.application.credentials.dig(:instagram, :client_secret).to_s
  REDIRECT_URI = if Rails.env.production?
                   instagram_callback_url
                 else
                   'https://insta2site.herokuapp.com/'
                   # 'https://insta2blog.com/instagram/callback'
                 end

  def authorize
    # Link to log in with instagram.
    authorize_url = 'https://api.instagram.com/oauth/authorize'
    redirect_to "#{authorize_url}?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&scope=user_profile,user_media&response_type=code",
                allow_other_host: true
  end

  # GET /instagram/callback/?code=
  def callback
    # Log in with instagram -> get authorization code via redirect callback.
    # "localhost:3000/instagram/callback/"
    code = params[:code]
    return head :bad_request unless code

    insta_user_id = InstaAuthService.new(code, REDIRECT_URI).call
    # return head :bad_request unless insta_user

    # https://binarysolo.chapter24.blog/demystifying-cookies-in-rails-6/
    # session[:s_token] = long_lived_access_token
    # cookies.signed[:s_token] = long_lived_access_token
    # cookies.encrypted[:e_token] = long_lived_access_token
    # cookies[:c_token] = insta_user.insta_access_token.access_token

    redirect_to insta_user_path(insta_user_id)
  end
end
