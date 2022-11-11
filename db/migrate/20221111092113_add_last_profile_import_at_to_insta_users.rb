class AddLastProfileImportAtToInstaUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :insta_users, :last_profile_import_at, :datetime
  end
end
