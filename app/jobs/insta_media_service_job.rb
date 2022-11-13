class InstaMediaServiceJob < ApplicationJob
  queue_as :default

  def perform(insta_user)
    InstaMediaService.new(insta_user).call
  end
end
