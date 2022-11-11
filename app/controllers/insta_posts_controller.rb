class InstaPostsController < ApplicationController
  before_action :set_user

  # rubocop:disable Metrics/AbcSize
  # GET /u/:id/p
  def index
    index_seo_tags
    cookies[:view] = params[:view] if params[:view].present? && %w[grid list].include?(params[:view])
    posts = @insta_user.insta_posts.order(timestamp: :desc)
    posts = if params[:caption].present?
              posts.where('caption ilike ?', "%#{params[:caption]}%")
            else
              posts
            end
    @pagy, @posts = pagy_countless(posts, items: items(cookies[:view]))
  end
  # rubocop:enable Metrics/AbcSize

  # GET /u/:id/p/:post_id
  def show
    @post = @insta_user.insta_posts.find(params[:post_id])
    show_seo_tags
    @posts = @insta_user.insta_posts.without(@post).order('RANDOM()').limit(6)
  end

  private

  def items(view)
    return 6 if cookies[:view].eql?('grid')

    3
  end

  def set_user
    @insta_user = InstaUser.find(params[:user_id])
    seo_tags
  end

  def index_seo_tags
    set_meta_tags title: ['Feed', @insta_user.username],
                  description: "#{@insta_user.username} feed with all posts",
                  keywords: [@insta_user.username, 'blog', 'instablog', 'instagram'],
                  author: @insta_user.username
  end

  def show_seo_tags
    set_meta_tags title: [@post.meta_title, @insta_user.username],
                  description: @post.meta_description,
                  keywords: @post.meta_keywords,
                  image_src: @post.meta_image,
                  author: @insta_user.username,
                  article: @post.meta_article,
                  twitter: @post.meta_twitter,
                  og: @post.meta_og
  end
end
