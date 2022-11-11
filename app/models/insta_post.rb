class InstaPost < ApplicationRecord
  belongs_to :insta_user, counter_cache: true
  validates :remote_id, presence: true, uniqueness: true
  enum media_type: { video: 'video', image: 'image', carousel_album: 'carousel_album' }

  extend FriendlyId
  friendly_id :remote_id, use: %i[finders]

  def bg_image_url
    return thumbnail_url if video?

    media_url
  end

  def meta_title
    # first sentence OR text before first line break
    word_count = 10
    title = caption.split[0...word_count].join(' ')
    title.truncate(70)
  end

  def meta_description
    # sentences 2,3,4?
    caption.truncate(300)
  end

  def meta_keywords
    [insta_user.username, 'blog', 'instablog', 'instagram']
    # TODO: caption.detected_hashtags
  end

  def meta_image
  end

  def meta_article
    {
      published_time: timestamp,
      modified_time: updated_at,
      section: 'Article Section',
      tag: 'Article Tag'
    }
  end

  def meta_twitter
    {
      card: 'summary',
      site: '@username'
    }
  end

  def meta_og
    {
      title: meta_title,
      type: 'video.movie',
      url: 'http://www.imdb.com/title/tt0117500/',
      image: meta_image,
      video: {
        director: 'http://www.imdb.com/name/nm0000881/',
        writer: ['http://www.imdb.com/name/nm0918711/', 'http://www.imdb.com/name/nm0177018/']
      }
    }
  end

  def meta_icon
    '/images/icons/itos-logo.png'
  end
end
