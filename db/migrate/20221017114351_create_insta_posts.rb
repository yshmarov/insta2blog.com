class CreateInstaPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :insta_posts do |t|
      t.bigint :remote_id
      t.text :caption
      t.string :media_type
      t.text :media_url
      t.text :permalink
      t.text :thumbnail_url
      t.datetime :timestamp
      t.references :insta_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
