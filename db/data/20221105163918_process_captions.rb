# frozen_string_literal: true

class ProcessCaptions < ActiveRecord::Migration[7.0]
  def up
    InstaPost.all.each do |insta_post|
      ProcessCaptionJob.perform_later(insta_post)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
