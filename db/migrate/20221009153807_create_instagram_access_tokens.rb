class CreateInstagramAccessTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :instagram_access_tokens do |t|
      t.string :access_token

      t.timestamps
    end
  end
end
