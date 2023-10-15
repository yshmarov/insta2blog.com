require 'test_helper'

class ProcessCaptionJobTest < ActiveJob::TestCase
  def setup
    @insta_user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
  end

  test 'should turn the hashtag to a url' do
    @insta_post = InstaPost.create(insta_user: @insta_user,
                                   remote_id: SecureRandom.random_number(9999),
                                   timestamp: Time.zone.now,
                                   caption: 'Post with a #hashtag')
    assert_nil @insta_post.processed_caption

    ProcessCaptionJob.perform_now(@insta_post)

    assert_equal processed_caption_text.squish, @insta_post.processed_caption
  end

  test 'should turn all mentions to urls' do
    @insta_post2 = InstaPost.create(insta_user: @insta_user, remote_id: SecureRandom.random_number(9999), timestamp: Time.zone.now,
                                    caption: 'a @mention and @yarotheslav')
    ProcessCaptionJob.perform_now(@insta_post2)
    text = 'a <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40mention&amp;onlypath=true">@mention</a> and <a data-turbo="false" class="mention font-semibold" href="/u/za-yuliia/p?caption=%40yarotheslav&amp;onlypath=true">@yarotheslav</a>'
    assert_equal text, @insta_post2.processed_caption
  end

  private

  def processed_caption_text
    <<~TEXT
      Post with a <a data-turbo="false" class="hashtag font-semibold" href="/u/za-yuliia/p?caption=%23hashtag&amp;onlypath=true">#hashtag</a>
    TEXT
  end
end
