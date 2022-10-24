# insta_user = InstaUser.first
# updated_insta_user = InstaMeService.new(insta_user).call
class InstaMeService
  attr_reader :insta_user, :insta_access_token

  def initialize(insta_user)
    @insta_user = insta_user
    @insta_access_token = insta_user.insta_access_tokens.last
  end

  def call
    insta_user_data = ask_user_profile
    insta_user.update(
      username: insta_user_data['username'],
      account_type: insta_user_data['account_type'].downcase,
      media_count: insta_user_data['media_count']
    )
  end

  private

  def ask_user_profile
    response = Faraday.get('https://graph.instagram.com/me') do |req|
      req.headers = headers,
                    req.params = user_params(insta_access_token.access_token)
    end
    JSON.parse(response.body)
    # {"id"=>"5973192396032263", "username"=>"yaro_the_slav", "account_type"=>"PERSONAL", "media_count"=>305}
  end

  def user_params(access_token)
    {
      fields: 'id,username,account_type,media_count',
      access_token:
    }
  end

  def headers
    { Accept: 'application/json' }
  end
end
