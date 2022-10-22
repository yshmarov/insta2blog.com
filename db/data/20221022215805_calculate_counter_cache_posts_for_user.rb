# frozen_string_literal: true

class CalculateCounterCachePostsForUser < ActiveRecord::Migration[7.0]
  def up
    InstaUser.find_each { |u| InstaUser.reset_counters(u.id, :insta_posts) }
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
