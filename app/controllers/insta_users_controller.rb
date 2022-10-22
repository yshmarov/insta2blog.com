class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @insta_users = InstaUser.all.order(created_at: :desc)
    set_meta_tags title: 'Blogs',
                  description: 'all instagram pages converted into blogs'
  end

  def show
    set_meta_tags title: @insta_user.username,
                  description: "#{@insta_user.username} blog website"
  end

  private

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
