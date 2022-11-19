class InstaCarouselJob < ApplicationJob
  queue_as :default

  def perform(insta_post)
    InstaCarouselService.new(insta_post).call
  end
end
