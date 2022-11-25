class RefreshExpiringInstaTokensJob < ApplicationJob
  queue_as :low_priority

  def perform
    InstaAccessToken.expiring.pluck(:id).each do |insta_access_token_id|
      RefreshInstaTokenJob.perform_later(insta_access_token_id)
    end
  end
end
