class AddProcessedCaptionToInstaPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_posts, :processed_caption, :text
  end
end
