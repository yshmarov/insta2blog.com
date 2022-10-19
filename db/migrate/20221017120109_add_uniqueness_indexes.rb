class AddUniquenessIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :insta_posts, :remote_id, unique: true
    add_index :insta_users, :remote_id, unique: true
    add_index :insta_users, :username, unique: true
  end
end
