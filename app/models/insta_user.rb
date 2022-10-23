class InstaUser < ApplicationRecord
  has_many :insta_posts, dependent: :destroy
  has_many :insta_access_tokens, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  validates :remote_id, presence: true, uniqueness: true
  enum account_type: { business: 'business', media_creator: 'media_creator', personal: 'personal' }

  extend FriendlyId
  friendly_id :username, use: %i[slugged finders]

  def at_username
    ['@', username].join
  end
end
