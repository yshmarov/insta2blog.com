class InstaUser < ApplicationRecord
  has_many :insta_posts, dependent: :destroy
  validates :username, uniqueness: true
  validates :remote_id, uniqueness: true
end
