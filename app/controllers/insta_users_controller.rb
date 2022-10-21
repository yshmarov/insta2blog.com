class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show posts]

  def index
    @insta_user = InstaUser.all.order(created_at: :desc)
  end

  def show
  end

  def posts
    @posts = InstaMediaService.new(@insta_user).call['data']
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
