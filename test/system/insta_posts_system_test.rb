require 'application_system_test_case'

class InstaPostsSystemTest < ApplicationSystemTestCase
  def setup
    @user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             media_type: 'image',
                             media_url: 'https://insta2blog.com',
                             caption: 'Post with a #hashtag and a second #hash')
    ProcessCaptionJob.perform_now(@post)
  end

  test 'insta_posts#show' do
    visit insta_user_post_url(@user, @post)

    assert_text 'Post with a #hashtag and a second #hash'
  end

  test 'insta_posts#index' do
    visit insta_user_posts_url(@user)
    assert_text 'Post with a #hashtag and a second #hash'

    select 'Carousel album', from: 'media_type'
    assert_no_text @post.caption
  end
end
