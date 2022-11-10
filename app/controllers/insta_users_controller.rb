class InstaUsersController < ApplicationController
  before_action :set_user, only: %i[show import destroy]
  before_action :require_user!, only: %i[import destroy]

  # GET /u
  def index
    @insta_users = InstaUser.where.not(insta_posts_count: 0).order(insta_posts_count: :desc)
    set_meta_tags title: 'Blogs',
                  description: 'all instagram pages converted into blogs'
  end

  # GET /u/:id
  def show
    redirect_to insta_user_posts_path(@insta_user)
  end

  # POST /u/:id/import
  def import
    return unless record_owner?

    # TODO: should trigger a job
    InstaMediaService.new(@insta_user).call
    redirect_to insta_user_posts_path(@insta_user), notice: t('.success')
  end

  # DELETE /u/:id
  def destroy
    return unless record_owner?

    @insta_user.destroy
    redirect_to user_path, notice: t('.success')
  end

  private

  def record_owner?
    @insta_user.user == current_user
  end

  def set_user
    @insta_user = InstaUser.find(params[:id])
  end
end
