class InstaMediaServiceJob < ApplicationJob
  queue_as :default

  def perform(insta_user)
    puts 'InstaMediaService...'
    InstaMediaService.new(insta_user).call
  end
end
