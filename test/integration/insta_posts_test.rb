require 'test_helper'

class InstaPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = InstaUser.create(username: 'yaro_the_slav', remote_id: SecureRandom.random_number(9999))
    @user.insta_access_tokens.create
  end

  test 'index' do
    InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                     caption: 'Post by this user')
    user2 = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    InstaPost.create(insta_user: user2, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                     caption: 'Post by other user')
    get insta_user_posts_url(@user)

    assert_response :success

    assert_match 'Post by this user', response.body
    assert_no_match 'Post by other user', response.body
  end

  test 'show' do
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now)
    get insta_user_post_url(@user, @post)
    assert_response :success
  end

  test 'import' do
    conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/https://graph.instagram.com/me/media') do |_env|
          [
            200,
            { Accept: 'application/json' },
            'shrimp'
          ]
        end

        # test exceptions too
        stub.get('/boom') do
          raise Faraday::ConnectionFailed
        end
      end
    end

    # skip # will stub faraday requests later
    post import_insta_user_posts_path(@user)
    assert_response :success
  end
end
