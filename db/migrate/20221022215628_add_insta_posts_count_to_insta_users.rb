class AddInstaPostsCountToInstaUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_users, :insta_posts_count, :integer, default: 0, null: false
  end
end
