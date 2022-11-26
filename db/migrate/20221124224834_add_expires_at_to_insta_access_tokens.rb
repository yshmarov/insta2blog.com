class AddExpiresAtToInstaAccessTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_access_tokens, :expires_at, :datetime, null: false, default: Time.zone.now
    change_column_default :insta_access_tokens, :expires_at, from: Time.zone.now, to: nil
  end
end
