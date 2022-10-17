class InstaUser < ApplicationRecord
  has_many :insta_posts, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  validates :remote_id, presence: true, uniqueness: true
end
