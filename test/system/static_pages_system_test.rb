require 'application_system_test_case'

class StaticPagesSystemTest < ApplicationSystemTestCase
  test 'static_pages#landing_page' do
    visit root_url

    assert_text 'Connect your Instagram'
  end
end
