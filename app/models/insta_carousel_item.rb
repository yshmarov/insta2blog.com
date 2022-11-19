class InstaCarouselItem < ApplicationRecord
  belongs_to :insta_post

  validates :remote_id, presence: true, uniqueness: true
end
