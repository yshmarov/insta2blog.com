class InstaAccessToken < ApplicationRecord
  belongs_to :insta_user, optional: true

  validates :access_token, :expires_in, :expires_at, presence: true

  scope :expiring, -> { where(expires_at: ..14.days.from_now) }
end
