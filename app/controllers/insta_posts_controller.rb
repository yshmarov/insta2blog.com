class InstaPostsController < ApplicationController
  before_action :set_user, only: %i[index show]

  def index
    # should not be called here. should be some button to "import" that would trigger a job.
    InstaMediaService.new(@insta_user).call unless Rails.env.development? # faster when not needed for now.
    # InstaMediaService.new(@insta_user).call

    posts = @insta_user.insta_posts.order(timestamp: :desc)
    @posts = if params[:caption].present?
               posts.where('caption ilike ?', "%#{params[:caption]}%")
             else
               posts
             end
  end

  def show
    @post = @insta_user.insta_posts.find(params[:post_id])
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
