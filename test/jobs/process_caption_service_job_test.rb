require 'test_helper'

class ProcessCaptionServiceJobTest < ActiveJob::TestCase
  def setup
    @user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @post = InstaPost.create(insta_user: @user,
                             remote_id: SecureRandom.random_number(9999),
                             timestamp: Time.zone.now,
                             caption: 'Post with a #hashtag')
  end

  test 'the truth' do
    assert_nil @post.processed_caption

    ProcessCaptionServiceJob.perform_now(@post)

    assert_equal processed_caption_text.squish, @post.processed_caption
  end

  private

  def processed_caption_text
    <<~TEXT
      Post with a <a data-turbo="false" class="hashtag font-semibold" href="/u/za-yuliia/p?caption=%23hashtag&amp;onlypath=true">#hashtag</a>
    TEXT
  end
end
