require 'application_system_test_case'

class InstaPostsTest < ApplicationSystemTestCase
  def setup
    @user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post with a #hashtag and a second #hash')
    ProcessCaptionService.new(@post).call
  end

  test 'insta_posts#show' do
    visit insta_user_post_url(@user, @post)

    assert_text 'Post with a #hashtag and a second #hash'
  end

  test 'insta_posts#index' do
    visit insta_user_posts_url(@user)

    assert_text 'Post with a #hashtag and a second #hash'
  end
end
