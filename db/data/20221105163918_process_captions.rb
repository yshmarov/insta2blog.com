# frozen_string_literal: true

class ProcessCaptions < ActiveRecord::Migration[7.0]
  def up
    InstaPost.all.each do |insta_post|
      ProcessCaptionService.new(insta_post).call
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
