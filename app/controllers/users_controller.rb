class UsersController < ApplicationController
  before_action :require_user!

  # GET /me
  def show
    @user = current_user
    @insta_users = @user.insta_users.order(created_at: :desc)
  end
end
