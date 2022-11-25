class RefreshInstaTokenJob < ApplicationJob
  queue_as :low_priority

  def perform(insta_access_token_id)
    InstaRefreshTokenService.new(insta_access_token_id).call
  end
end
