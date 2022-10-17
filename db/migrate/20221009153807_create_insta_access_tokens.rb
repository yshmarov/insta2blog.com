class CreateInstaAccessTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :insta_access_tokens do |t|
      t.string :access_token
      t.integer :expires_in

      t.timestamps
    end
  end
end
