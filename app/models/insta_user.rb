class InstaUser < ApplicationRecord
  has_many :insta_medias, dependent: :destroy
  validates :username, uniqueness: true
  validates :remote_id, uniqueness: true
end
