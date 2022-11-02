# insta_user = InstaUser.first
# posts = InstaMediaService.new(insta_user).call
class InstaMediaService
  attr_reader :insta_user, :insta_access_token

  def initialize(insta_user)
    @insta_user = insta_user
    @insta_access_token = insta_user.insta_access_tokens.last
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

    page1 = JSON.parse(response.body)

    items = page1['data']
    update_or_create_records(items)

    # CAROUSEL_ALBUM children:
    # https://developers.facebook.com/docs/instagram-basic-display-api/reference/media/children#reading

    # should be a loop
    # next_page_url = page1.dig('paging', 'next')
    # return unless next_page_url.present?

    # page2 = Faraday.get(next_page_url) do |request|
    #   request.headers = headers,
    #                     request.params = media_params(insta_access_token.access_token)
    # end

    # items2 = JSON.parse(page2.body)
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
