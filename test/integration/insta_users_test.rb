# bin/rails generate integration_test sessions
require 'test_helper'

# rubocop:disable Metrics/MethodLength, Layout/LineLength, Metrics/ClassLength
class InstaUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @insta_user = InstaUser.create(username: 'yaro_the_slav', media_count: 5, remote_id: '123', user: @user)
    @insta_user.insta_access_tokens.create(access_token: 'ABCDE', expires_in: 40_000, expires_at: Time.zone.now + 40_000)
  end

  test 'index' do
    get insta_users_url
    assert_response :success
  end

  test 'show' do
    get insta_user_url(@insta_user)
    assert_response :redirect
    assert_redirected_to insta_user_posts_path(@insta_user)

    follow_redirect!
    assert_response :success
    assert_match @insta_user.username, @response.body
  end

  test 'import' do
    passwordless_sign_in(@user)

    stub_request(:get, 'https://graph.instagram.com/me/media?access_token&fields=id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username')
      .to_return(status: 200, body: response_body.to_json)
    stub_request(:get, 'https://graph.instagram.com/v15.0/12345/media?access_token=IGQVJY&fields=id%2Ccaption%2Cmedia_type%2Cmedia_url%2Cpermalink%2Cthumbnail_url%2Ctimestamp%2Cusername&limit=25&after=DEF')
      .to_return(status: 200, body: paginated_response_body.to_json)

    post import_insta_user_path(@insta_user, format: :turbo_stream)
    assert_response :success
    assert_match 'Posts are being imported. This can take a few minutes', @response.body
  end

  test '#media_count' do
    stub_ask_user_profile

    passwordless_sign_in(@user)
    assert_equal 5, @insta_user.media_count
    get media_count_insta_user_path(@user.insta_users.first, format: :turbo_stream)
    assert_response :success
    @insta_user.reload
    assert_equal 67, @insta_user.media_count

    get user_path(@user)
    assert_response :success
    assert_match '67', @response.body
  end

  test '#delete' do
    passwordless_sign_in(@user)

    get user_path
    assert_match @insta_user.username, @response.body

    delete delete_insta_user_path(@insta_user)
    assert_response :redirect
    assert_redirected_to user_path

    follow_redirect!
    assert_response :success
    assert_no_match @insta_user.username, @response.body
  end

  private

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
       'username' => 'yaro_the_slav' }],
      'paging' =>
       { 'cursors' =>
        { 'before' => 'ABC',
          'after' => 'XYZ' },
         'next' =>
        'https://graph.instagram.com/v15.0/12345/media?access_token=IGQVJY&fields=id%2Ccaption%2Cmedia_type%2Cmedia_url%2Cpermalink%2Cthumbnail_url%2Ctimestamp%2Cusername&limit=25&after=DEF' } }
  end

  def paginated_response_body
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

  def stub_ask_user_profile
    me_url = 'https://graph.instagram.com/me'
    me_body = { 'id' => '123', 'username' => 'yaro_the_slav', 'account_type' => 'PERSONAL', 'media_count' => 67 }
    stub_request(:get, "#{me_url}?access_token=ABCDE&fields=id,username,account_type,media_count")
      .to_return(status: 200, body: me_body.to_json, headers: {})
  end
end
# rubocop:enable Metrics/MethodLength, Layout/LineLength, Metrics/ClassLength
