class ProcessCaptionServiceJob < ApplicationJob
  queue_as :default

  def perform(insta_post)
    ProcessCaptionService.new(insta_post).call
  end
end
