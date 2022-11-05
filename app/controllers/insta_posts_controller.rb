class InstaPostsController < ApplicationController
  before_action :set_user

  def index
    cookies[:view] = params[:view] if params[:view].present? && %w[grid list].include?(params[:view])

    posts = @insta_user.insta_posts.order(timestamp: :desc)
    @posts = if params[:caption].present?
               posts.where('caption ilike ?', "%#{params[:caption]}%")
             else
               posts
             end
  end

  def import
    # TODO: should (also) trigger by a job
    InstaMediaService.new(@insta_user).call
    redirect_to insta_user_posts_path(@insta_user), notice: t('.success')
  end

  def show
    @post = @insta_user.insta_posts.find(params[:post_id])
    @posts = InstaPost.without(@post).limit(6)
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
    seo_tags
  end

  def seo_tags
    set_meta_tags title: @insta_user.username,
                  description: "#{@insta_user.username} blog website"
  end
end
