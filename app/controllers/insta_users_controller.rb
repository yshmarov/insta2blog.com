class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @insta_users = InstaUser.all.order(insta_posts_count: :desc)
    set_meta_tags title: 'Blogs',
                  description: 'all instagram pages converted into blogs'
  end

  def show
    set_meta_tags title: @insta_user.username,
                  description: "#{@insta_user.username} blog website"
    # redirect_to root_path, notice: 'abc'
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
