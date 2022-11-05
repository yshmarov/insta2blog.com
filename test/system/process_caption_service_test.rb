require 'test_helper'

# rubocop:disable Layout/LineLength
class ProcessCaptionServiceTest < ActiveSupport::TestCase
  def setup
    @user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @post = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                             caption: 'Post with a #hashtag')
    @post2 = InstaPost.create(insta_user: @user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                              caption: 'a @mention and @yarotheslav')
  end

  test 'should turn the hashtag to a url' do
    text = 'Post with a <a data-turbo="false" class="hashtag font-semibold" href="/u/za-yuliia/p?caption=%23hashtag&amp;onlypath=true">#hashtag</a>'
    assert_equal text, @post.processed_caption
  end

  test 'should turn all mentions to urls' do
    text = 'a <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40mention&amp;onlypath=true">@mention</a> and <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40yarotheslav&amp;onlypath=true">@yarotheslav</a>'
    assert_equal text, @post2.processed_caption
  end
end
# rubocop:enable Layout/LineLength
