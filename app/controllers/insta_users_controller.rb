class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show import]
  before_action :require_user!, only: :import

  # discovery
  def index
    @insta_users = InstaUser.where.not(insta_posts_count: 0).order(insta_posts_count: :desc)
    set_meta_tags title: 'Blogs',
                  description: 'all instagram pages converted into blogs'
  end

  # IG account settings
  def show
    redirect_to insta_user_posts_path(@insta_user)
  end

  def import
    return unless @insta_user.user == current_user

    # TODO: should (also) trigger by a job
    InstaMediaService.new(@insta_user).call
    redirect_to insta_user_posts_path(@insta_user), notice: t('.success')
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
