class AddSlugToInstaUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_users, :slug, :string
    add_index :insta_users, :slug, unique: true
  end
end
