require 'test_helper'

# rubocop:disable Metrics/MethodLength, Layout/LineLength
class InstaPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: SecureRandom.random_number(9999))
    @user.insta_access_tokens.create
  end

  test 'index' do
    post1 = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post by this user')
    user2 = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    post2 = InstaPost.create(insta_user: user2, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post by other user')
    ProcessCaptionService.new(post1).call
    ProcessCaptionService.new(post2).call

    get insta_user_posts_url(@user)

    assert_response :success

    assert_match 'Post by this user', response.body
    assert_no_match 'Post by other user', response.body
  end

  test 'show' do
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now, caption: 'some text')
    get insta_user_post_url(@user, @post)
    assert_response :success
    assert_no_match 'More posts from', @response.body
    assert_no_match 'some text', response.body

    # when user has other posts, displays "more posts from"
    InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now, media_url: 'itos-logo.png')
    get insta_user_post_url(@user, @post)
    assert_response :success
    assert_match 'More posts from', @response.body

    # displays body if ProcessCaptionService was run
    ProcessCaptionService.new(@post).call
    get insta_user_post_url(@user, @post)
    assert_response :success
    assert_match 'some text', response.body
  end

  test 'import' do
    stub_request(:get, 'https://graph.instagram.com/me/media?access_token&fields=id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username')
      .to_return(status: 200, body: response_body.to_json, headers: {})

    post import_insta_user_posts_path(@user)
    assert_response :redirect

    assert_redirected_to insta_user_posts_path(InstaUser.last)

    follow_redirect!
    assert_response :success
    assert_match 'Run forest', @response.body
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
end
# rubocop:enable Metrics/MethodLength, Layout/LineLength
