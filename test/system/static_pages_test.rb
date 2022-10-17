require 'application_system_test_case'

class StaticPagesTest < ApplicationSystemTestCase
  test 'visiting the homepage' do
    visit root_url

    assert_text 'Instagram login'
  end
end
