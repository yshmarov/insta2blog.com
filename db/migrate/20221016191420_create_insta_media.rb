class CreateInstaMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :insta_media do |t|
      t.bigint :remote_id
      t.text :caption
      t.string :media_type
      t.text :media_url
      t.text :permalink
      t.datetime :timestamp
      t.references :insta_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
