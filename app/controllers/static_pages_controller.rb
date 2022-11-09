class StaticPagesController < ApplicationController
  before_action :seo_tags, only: %i[terms privacy pricing]

  # GET /
  def landing_page
    count = InstaUser.count
    random_offset = rand(count)
    @random_user = InstaUser.offset(random_offset).first
  end

  # GET /terms
  def terms; end

  # GET /privacy
  def privacy; end

  # GET /pricing
  def pricing; end

  private

  def seo_tags
    set_meta_tags title: action_name.capitalize
  end
end
