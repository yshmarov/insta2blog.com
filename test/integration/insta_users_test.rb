# bin/rails generate integration_test sessions
require 'test_helper'

class InstaUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: '123')
  end

  test 'index' do
    get insta_users_url
    assert_response :success
  end

  test 'show' do
    get insta_user_url(@user)
    assert_response :success
  end
end
