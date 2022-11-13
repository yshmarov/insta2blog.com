require 'test_helper'

class ProcessCaptionServiceJobTest < ActiveJob::TestCase
  def setup
    @insta_user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @insta_post = InstaPost.create(insta_user: @insta_user,
                                   remote_id: SecureRandom.random_number(9999),
                                   timestamp: Time.zone.now,
                                   caption: 'Post with a #hashtag')
  end

  test 'runs job and updates processed_caption' do
    assert_nil @insta_post.processed_caption

    ProcessCaptionServiceJob.perform_now(@insta_post)

    assert_equal processed_caption_text.squish, @insta_post.processed_caption
  end

  private

  def processed_caption_text
    <<~TEXT
      Post with a <a data-turbo="false" class="hashtag font-semibold" href="/u/za-yuliia/p?caption=%23hashtag&amp;onlypath=true">#hashtag</a>
    TEXT
  end
end
