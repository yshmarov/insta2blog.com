# insta_user = InstaUser.first
# posts = InstaMediaService.new(insta_user).call
class InstaMediaService
  attr_reader :insta_user, :insta_access_token

  def initialize(insta_user)
    @insta_user = insta_user
    @insta_access_token = insta_user.insta_access_tokens.active.last
  end

  def call
    ask_media
    insta_user.update(last_import_at: Time.zone.now)
  end

  private

  def ask_media
    response = Faraday.get('https://graph.instagram.com/me/media') do |request|
      request.headers = headers,
                        request.params = media_params(insta_access_token.access_token)
    end

    next_page_link = parse_and_create_records(response)

    loop do
      response = Faraday.get(next_page_link) if next_page_link.present?
      next_page_link = parse_and_create_records(response)
      break if next_page_link.nil?
    end

    # CAROUSEL_ALBUM children:
    # https://developers.facebook.com/docs/instagram-basic-display-api/reference/media/children#reading
  end

  def parse_and_create_records(response)
    page = JSON.parse(response.body)
    items = page['data']
    update_or_create_records(items)
    page.dig('paging', 'next')
  end

  def update_or_create_records(items)
    items.each do |item|
      insta_post = InstaPost.find_or_create_by(remote_id: item['id'].to_i)
      insta_post.update(
        caption: item['caption'],
        media_type: item['media_type'].downcase,
        media_url: item['media_url'],
        permalink: item['permalink'],
        thumbnail_url: item['thumbnail_url'],
        timestamp: item['timestamp'],
        insta_user:
      )
      InstaCarouselJob.perform_later(insta_post) if insta_post.carousel_album?
      ProcessCaptionJob.perform_later(insta_post) if insta_post.caption.present?
    end
  end

  def headers
    { Accept: 'application/json' }
  end

  def media_params(access_token)
    {
      fields: 'id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username',
      access_token:
    }
  end
end
