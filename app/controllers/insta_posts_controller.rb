class InstaPostsController < ApplicationController
  before_action :set_user

  # rubocop:disable Metrics/AbcSize
  # GET /u/:id/p
  def index
    cookies[:view] = params[:view] if params[:view].present? && %w[grid list].include?(params[:view])
    @page_list_spacing = 'space-y-4' if cookies[:view].eql?('list')

    posts = @insta_user.insta_posts.order(timestamp: :desc)
    posts = posts.where('caption ilike ?', "%#{params[:caption]}%") if params[:caption].present?
    posts = posts.where(media_type: params[:media_type]) if params[:media_type].present?
    @pagy, @posts = pagy_countless(posts, items: items(cookies[:view]))

    @skip_footer = true
  end
  # rubocop:enable Metrics/AbcSize

  # GET /u/:id/p/:post_id
  def show
    @post = @insta_user.insta_posts.find(params[:id])
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

  def seo_tags
    set_meta_tags title: @insta_user.username,
                  description: "#{@insta_user.username} blog website"
  end
end
