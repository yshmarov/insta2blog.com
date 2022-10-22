class InstaPost < ApplicationRecord
  belongs_to :insta_user
  validates :remote_id, presence: true, uniqueness: true
  enum media_type: { video: 'video', image: 'image', carousel_album: 'carousel_album' }
end
