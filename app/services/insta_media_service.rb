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
  end

  private

  def ask_media
    response = Faraday.get('https://graph.instagram.com/me/media') do |request|
      request.headers = headers,
                        request.params = media_params(insta_access_token.access_token)
    end

    JSON.parse(response.body)

    # interate through all pages of records
    # if body['next_link'].present?
    #   new_request with new_url loop do
    # end

    # insta_user.insta_posts.find_or_create_by()
    # body['data'].each do |record|
    # end
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
