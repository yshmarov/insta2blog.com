class InstaPost < ApplicationRecord
  belongs_to :insta_user, counter_cache: true

  has_many :insta_carousel_items, dependent: :destroy

  validates :remote_id, presence: true, uniqueness: true

  enum media_type: { video: 'video', image: 'image', carousel_album: 'carousel_album' }

  extend FriendlyId
  friendly_id :remote_id, use: %i[finders]

  def bg_image_url
    return thumbnail_url if video?

    media_url
  end
end
