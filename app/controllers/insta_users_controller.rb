class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show posts]

  def index
    @insta_user = InstaUser.all.order(created_at: :desc)
  end

  def show
  end

  def posts
    # should not be called here. should be some button to "import" that would trigger a job.
    InstaMediaService.new(@insta_user).call

    @posts = InstaPost.carousel_album.order(timestamp: :desc)
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
