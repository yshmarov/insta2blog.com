require 'test_helper'

# rubocop:disable Layout/LineLength
class InstaPostsTest < ActionDispatch::IntegrationTest
  def setup
    @insta_user = InstaUser.create(username: 'yaro_the_slav', remote_id: SecureRandom.random_number(9999))
  end

  test 'index' do
    post1 = InstaPost.create(insta_user: @insta_user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post by this user')
    user2 = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    post2 = InstaPost.create(insta_user: user2, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post by other user')
    ProcessCaptionService.new(post1).call
    ProcessCaptionService.new(post2).call

    get insta_user_posts_url(@insta_user)

    assert_response :success
    assert_match 'Find a post', response.body
    assert_no_match 'Post by this user', response.body
    assert_no_match 'Post by other user', response.body

    get insta_user_posts_url(@insta_user, format: :turbo_stream)
    assert_match 'Post by this user', response.body
    assert_no_match 'Post by other user', response.body
  end

  test 'show' do
    @post = InstaPost.create(insta_user: @insta_user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now, caption: 'some text')
    get insta_user_post_url(@insta_user, @post)
    assert_response :success
    assert_no_match 'More posts from', @response.body
    assert_no_match 'some text', response.body

    # when user has other posts, displays "more posts from"
    InstaPost.create(insta_user: @insta_user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now, media_url: 'itos-logo.png')
    get insta_user_post_url(@insta_user, @post)
    assert_response :success
    assert_match 'More posts from', @response.body

    # displays body if ProcessCaptionService was run
    ProcessCaptionService.new(@post).call
    get insta_user_post_url(@insta_user, @post)
    assert_response :success
    assert_match 'some text', response.body
  end
end
# rubocop:enable Layout/LineLength
