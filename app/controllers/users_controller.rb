class UsersController < ApplicationController
  before_action :require_user!

  def show
    @user = current_user
    @insta_users = @user.insta_users
  end
end
