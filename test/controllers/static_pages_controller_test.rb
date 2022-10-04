require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get landing_page' do
    get root_url
    assert_response :success
  end

  test 'should get pricing' do
    get pricing_url
    assert_response :success
  end

  test 'should get terms' do
    get terms_url
    assert_response :success
  end

  test 'should get privacy' do
    get privacy_url
    assert_response :success
  end
end
