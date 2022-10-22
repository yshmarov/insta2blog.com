class InstaPostsController < ApplicationController
  before_action :set_user, only: %i[index]

  def index
    # should not be called here. should be some button to "import" that would trigger a job.
    InstaMediaService.new(@insta_user).call

    posts = @insta_user.insta_posts.order(timestamp: :desc)
    @posts = if params[:caption].present?
               posts.where('caption ilike ?', "%#{params[:caption]}%")
             else
               posts
             end
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
