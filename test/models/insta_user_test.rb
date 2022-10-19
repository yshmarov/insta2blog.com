require 'test_helper'

# https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-minitest
class InstaUserTest < ActiveSupport::TestCase
  def setup
    @user = InstaUser.new(username: 'yaro_the_slav', remote_id: '123')
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without remote_id' do
    @user.remote_id = nil
    assert_not @user.valid?, 'user is valid without a remote_id'
    assert_not_nil @user.errors[:remote_id], 'no validation error for remote_id present'
  end

  test 'invalid without username' do
    @user.username = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:email]
  end
end
