class InstaUser < ApplicationRecord
  has_many :insta_posts, dependent: :destroy
  has_many :insta_access_tokens, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  validates :remote_id, presence: true, uniqueness: true
  # enum account_types: { BUSINESS, MEDIA_CREATOR, PERSONAL }
end
