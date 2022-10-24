class StaticPagesController < ApplicationController
  before_action :seo_tags, only: %i[terms privacy pricing]
  def landing_page
    count = InstaUser.count
    random_offset = rand(count)
    @random_user = InstaUser.offset(random_offset).first
  end

  def terms; end
  def privacy; end
  def pricing; end

  private

  def seo_tags
    set_meta_tags title: action_name.capitalize
  end
end
