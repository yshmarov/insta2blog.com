class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  passwordless_with :email

  def self.fetch_resource_for_passwordless(email)
    find_or_create_by(email:)
  end
end
