class InstaPostsController < ApplicationController
  before_action :set_user, only: %i[index]

  def index
    InstaMediaService.new(@insta_user).call
    @posts = @insta_user.insta_posts.order(timestamp: :desc)
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
