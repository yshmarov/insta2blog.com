class AddUserIdToInstaUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :insta_users, :user, foreign_key: true
  end
end
