require 'test_helper'

class InstaPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: '123')
    @user.insta_access_tokens.create
  end

  test 'posts' do
    skip # will stub faraday requests later
    get insta_user_posts_url(@user)
    assert_response :success
  end
end
