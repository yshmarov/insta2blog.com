require 'test_helper'

class InstaPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: 123)
    @user.insta_access_tokens.create
  end

  test 'index' do
    skip # will stub faraday requests later
    get insta_user_posts_url(@user)
    assert_response :success
  end

  test 'show' do
    @post = InstaPost.create(insta_user: @user, remote_id: 123, timestamp: Time.zone.now)
    get insta_user_post_url(@user, @post)
    assert_response :success
  end
end
