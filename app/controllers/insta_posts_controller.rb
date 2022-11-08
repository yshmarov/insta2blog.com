class InstaPostsController < ApplicationController
  before_action :set_user

  # all posts
  def index
    cookies[:view] = params[:view] if params[:view].present? && %w[grid list].include?(params[:view])

    posts = @insta_user.insta_posts.order(timestamp: :desc)
    @posts = if params[:caption].present?
               posts.where('caption ilike ?', "%#{params[:caption]}%")
             else
               posts
             end
  end

  # single post
  def show
    @post = @insta_user.insta_posts.find(params[:post_id])
    @posts = @insta_user.insta_posts.without(@post).order('RANDOM()').limit(6)
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
