require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  test 'logout' do
    delete logout_path
    assert_response :redirect
  end
end
