require 'test_helper'

class InstagramTest < ActionDispatch::IntegrationTest
  test 'authorize' do
    get instagram_authorize_url
    assert_response :redirect
  end

  test 'callback' do
    get instagram_callback_url(code: 'abc')
    assert_response :success
  end
end
