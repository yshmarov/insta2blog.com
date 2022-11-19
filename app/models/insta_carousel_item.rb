class InstaCarouselItem < ApplicationRecord
  belongs_to :insta_post, counter_cache: true

  validates :remote_id, presence: true, uniqueness: true

  enum media_type: { video: 'video', image: 'image', carousel_album: 'carousel_album' }
end
