# CAROUSEL_ALBUM children:
# https://developers.facebook.com/docs/instagram-basic-display-api/reference/media/children#reading

# insta_post = InstaPost.carousel_album.first
# insta_post = InstaCarouselService.new(insta_post).call
class InstaCarouselService
  attr_reader :insta_post, :insta_access_token

  def initialize(insta_post)
    @insta_post = insta_post
    @insta_access_token = insta_post.insta_user.insta_access_tokens.last
  end

  def callable?
    insta_post.carousel_album?
  end

  def call
    return unless callable?

    ask_media_children(insta_post.remote_id, insta_access_token.access_token)
  end

  private

  def ask_media_children(id, access_token)
    response = Faraday.get("https://graph.instagram.com/#{id}/children") do |request|
      request.headers = headers,
                        request.params = { access_token: }
    end

    page = JSON.parse(response.body)
    items = page['data']
    items.each do |item|
      id = item['id']
      ask_media_id(id, access_token)
    end
  end

  def ask_media_id(id, access_token)
    response = Faraday.get("https://graph.instagram.com/#{id}") do |request|
      request.headers = headers,
                        request.params = {
                          fields: 'id,media_url',
                          access_token:
                        }
    end

    item = JSON.parse(response.body)
    insta_carousel_item = insta_post.insta_carousel_items
                                    .find_or_create_by(remote_id: item['id'])
    insta_carousel_item.update(media_url: item['media_url'])
  end

  def headers
    { Accept: 'application/json' }
  end

  # X?
  def media_params(access_token)
    {
      fields: 'id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username',
      access_token:
    }
  end
end
