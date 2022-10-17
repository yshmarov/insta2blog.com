class CreateInstaUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :insta_users do |t|
      t.bigint :remote_id
      t.string :username
      t.string :account_type
      t.integer :media_count, default: 0, null: false

      t.timestamps
    end
  end
end
