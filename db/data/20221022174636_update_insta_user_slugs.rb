# frozen_string_literal: true

class UpdateInstaUserSlugs < ActiveRecord::Migration[7.0]
  def up
    InstaUser.find_each(&:save)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
