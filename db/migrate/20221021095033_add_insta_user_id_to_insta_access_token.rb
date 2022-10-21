class AddInstaUserIdToInstaAccessToken < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_access_tokens, :insta_user_id, :bigint
  end
end
