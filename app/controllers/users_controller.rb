class UsersController < ApplicationController
  def show
    @user = current_user
    @insta_users = @user.insta_users
  end
end
