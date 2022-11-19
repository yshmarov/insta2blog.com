class InstaCarouselItem < ApplicationRecord
  belongs_to :insta_post, counter_cache: true

  validates :remote_id, presence: true, uniqueness: true
end
