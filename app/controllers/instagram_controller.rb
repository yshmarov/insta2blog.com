# connect/disconnect instagram account
class InstagramController < ApplicationController
  CLIENT_ID = Rails.application.credentials.dig(:instagram, :client_id).to_s
  CLIENT_SECRET = Rails.application.credentials.dig(:instagram, :client_secret).to_s

  # GET /instagram/authorize
  def authorize
    # Link to log in with instagram.
    authorize_url = 'https://api.instagram.com/oauth/authorize'
    redirect_to "#{authorize_url}?client_id=#{CLIENT_ID}&redirect_uri=#{redirect_uri}&scope=user_profile,user_media&response_type=code",
                allow_other_host: true
  end

  # GET /instagram/callback/?code=
  def callback
    # Log in with instagram -> get authorization code via redirect callback.
    code = params[:code]
    return head :bad_request unless code

    insta_user_id = InstaAuthService.new(code, redirect_uri).call
    return head :bad_request unless insta_user_id

    insta_user = InstaUser.find(insta_user_id)
    insta_user.update(user: current_user)

    redirect_to user_path, notice: t('.success', username: insta_user.username)
  end

  # GET /instagram/delete
  def delete
    # TODO: deauthorize instagram account, delete user, delete all posts
    render plain: t('.notice', email: ApplicationMailer.default_params[:from])
  end

  # GET /instagram/deauthorize
  def deauthorize
    # TODO: deauthorize instagram account. Do not delete user and posts
    render plain: t('.notice', email: ApplicationMailer.default_params[:from])
  end

  private

  def redirect_uri
    if Rails.env.production?
      instagram_callback_url
      # 'https://insta2blog.com/instagram/callback'
    else
      'https://localhost:3000/instagram/callback'
    end
  end
end
