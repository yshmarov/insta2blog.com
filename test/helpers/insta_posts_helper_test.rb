# rubocop:disable Layout/LineLength
class InstaPostsHelperTest < ActionView::TestCase
  def setup
    @user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post with a #hashtag')
    @post2 = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                              caption: 'a @mention and @yarotheslav')
  end

  test 'should turn the hashtag to a url' do
    skip
    assert_dom_equal %(Post with a <a data-turbo="false" class="hashtag font-semibold" href="/u/za-yuliia/p?caption=%23hashtag">#hashtag</a>),
                     with_regex(@post)
  end

  test 'should turn all mentions to urls' do
    skip
    assert_dom_equal %(a <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40mention">@mention</a> and <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40yarotheslav">@yarotheslav</a>),
                     with_regex(@post2)
  end
end
# rubocop:enable Layout/LineLength
