# insta_user = InstaMeService.new(insta_user).call
class InstaMeService
  attr_reader :long_lived_access_token

  def initialize(long_lived_access_token)
    @long_lived_access_token = long_lived_access_token
  end

  def call
    insta_user_data = ask_user_profile
    insta_user = InstaUser.find_or_initialize_by(username: insta_user_data['username'])
    insta_user.update(
      remote_id: insta_user_data['id'],
      account_type: insta_user_data['account_type'].downcase,
      media_count: insta_user_data['media_count']
    )
    insta_user
  end

  private

  def ask_user_profile
    response = Faraday.get('https://graph.instagram.com/me') do |req|
      req.headers = headers,
                    req.params = user_params(long_lived_access_token)
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
