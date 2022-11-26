# frozen_string_literal: true

class UpdateInstaAccessTokenExpiresAt < ActiveRecord::Migration[7.0]
  def up
    InstaAccessToken.expiring.pluck(:id).each do |insta_access_token_id|
        RefreshInstaTokenJob.perform_later(insta_access_token_id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
