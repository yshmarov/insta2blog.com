class UpgradePassswordless < ActiveRecord::Migration[7.1]
  def change
    # Encrypted tokens
    add_column(:passwordless_sessions, :token_digest, :string)
    add_index(:passwordless_sessions, :token_digest)
    remove_column(:passwordless_sessions, :token, :string, null: false)

    # Remove PII
    remove_column(:passwordless_sessions, :user_agent, :string, null: false)
    remove_column(:passwordless_sessions, :remote_addr, :string, null: false)
  end
end
