class InstaPostsHelperTest < ActionView::TestCase
  test "should return the user's full name" do
    user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    post = InstaPost.create(insta_user: user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                            caption: 'Post with a #hashtag')

    assert_dom_equal %(Post with a <a data-turbo="false" class="hashtag" href="/u/za-yuliia/p?caption=%23hashtag">#hashtag</a>),
                     with_hashtags(post)
  end
end
