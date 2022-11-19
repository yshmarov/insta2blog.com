class CreateInstaCarouselItems < ActiveRecord::Migration[7.0]
  def change
    create_table :insta_carousel_items do |t|
      t.bigint :remote_id
      t.string :media_url
      t.references :insta_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
