class InstaPost < ApplicationRecord
  belongs_to :insta_user
  validates :remote_id, presence: true, uniqueness: true
  # enum media_types: { IMAGE, VIDEO, CAROUSEL_ALBUM }
  # CAROUSEL_ALBUM children:
  # https://developers.facebook.com/docs/instagram-basic-display-api/reference/media/children#reading
end
