# bin/rails generate integration_test sessions
require 'test_helper'

class InstaUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: '123')
    @user.insta_access_tokens.create
  end

  test 'index' do
    get insta_users_url
    assert_response :success
  end

  test 'show' do
    get insta_user_url(@user)
    assert_response :success
  end

  test 'posts' do
    get insta_user_posts_url(@user)
    assert_response :success
  end
end
