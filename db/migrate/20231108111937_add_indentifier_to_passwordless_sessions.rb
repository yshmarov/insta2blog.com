class AddIndentifierToPasswordlessSessions < ActiveRecord::Migration[7.1]
  def change
    add_column(:passwordless_sessions, :identifier, :string)
    add_index(:passwordless_sessions, :identifier, unique: true)
  end
end
