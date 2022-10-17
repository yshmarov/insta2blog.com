class InstaUser < ApplicationRecord
  has_many :insta_medias
  # validates :username, uniqueness: true
end
