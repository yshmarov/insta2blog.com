class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show import destroy media_count]
  before_action :require_user!, only: %i[import destroy media_count]

  # GET /u
  def index
    @insta_users = InstaUser.where.not(insta_posts_count: 0).order(insta_posts_count: :desc)
    set_meta_tags title: 'Blogs',
                  description: 'all instagram pages converted into blogs'
  end

  # GET /u/:id
  def show
    redirect_to insta_user_posts_path(@insta_user)
  end

  # POST /u/:id/import
  def import
    return unless record_owner?

    InstaMediaJob.perform_later(@insta_user)
    flash.now[:notice] = t('.processing')
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update('flash', partial: 'shared/flash')
      end
    end
  end

  # GET /u/:id/media_count
  def media_count
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("#{@insta_user.id}_media_count",
                                                 html: check_media_count(@insta_user))
      end
    end
  end

  # DELETE /u/:id
  def destroy
    return unless record_owner?

    @insta_user.destroy
    redirect_to user_path, notice: t('.success')
  end

  private

  def check_media_count(insta_user)
    return refresh_media_count(insta_user) if insta_user.last_profile_import_at.nil?
    return insta_user.media_count if insta_user.last_profile_import_at > 15.minutes.ago

    refresh_media_count(insta_user)
  end

  def refresh_media_count(insta_user)
    insta_access_token = insta_user.insta_access_tokens.active.last
    insta_user = InstaMeService.new(insta_access_token.access_token).call
    insta_user.media_count
  end

  def record_owner?
    @insta_user.user == current_user
  end

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
