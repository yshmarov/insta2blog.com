require 'test_helper'

class InstaMediaJobTest < ActiveJob::TestCase
  def setup
    @insta_user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    # @insta_access_token = @insta_user.insta_access_tokens.create
    @insta_user.insta_access_tokens.create(access_token: 'ABCDE', expires_in: 40_000, expires_at: Time.zone.now + 40_000)
  end

  test 'imports posts from instagram api' do
    assert_equal @insta_user.insta_posts.count, 0

    access_token = @insta_user.insta_access_tokens.active.last.access_token

    stub_request(:get, "https://graph.instagram.com/me/media?access_token=#{access_token}&fields=id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username")
      .to_return(status: 200, body: response_body.to_json)

    InstaMediaJob.perform_now(@insta_user)

    assert_equal 2, @insta_user.insta_posts.count
    assert_equal 2, @insta_user.reload.insta_posts_count
  end

  private

  # rubocop:disable Metrics/MethodLength
  def response_body
    { 'data' =>
      [{ 'id' => '179275846',
         'caption' => 'Run forest run 🏃‍♂️ 🐕',
         'media_type' => 'IMAGE',
         'media_url' =>
         'https://scontent.cdninstagram.com/v/t51.29350-15/3115039.jpg?_nc_cat=101&ccb=1-7&_nc_sid=8ae9d6&_nc_ohc=E2D66GZ',
         'permalink' => 'https://www.instagram.com/p/CjqhZZ/',
         'timestamp' => '2022-10-13T18:44:12+0000',
         'username' => 'yaro_the_slav' },
       { 'id' => '1791585433',
         'caption' => 'Piadina - something between a Calzone and a Taco. Yum yum!😋',
         'media_type' => 'IMAGE',
         'media_url' =>
         'https://scontent.cdninstagram.com/v/t51.29350-15/26127.jpg?_nc_cat=106&ccb=1-7&_nc_sid=8ae9d6&_nc_ohc=fQNiTMukNTQ',
         'permalink' => 'https://www.instagram.com/p/CWx4Xqh/',
         'timestamp' => '2021-11-27T12:31:30+0000',
         'username' => 'yaro_the_slav' }] }
  end
  # rubocop:enable Metrics/MethodLength
end
