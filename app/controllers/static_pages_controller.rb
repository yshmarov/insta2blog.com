class StaticPagesController < ApplicationController
  before_action :seo_tags, only: %i[terms privacy pricing]
  def landing_page; end
  def terms; end
  def privacy; end
  def pricing; end

  private

  def seo_tags
    set_meta_tags title: action_name.capitalize
  end
end
