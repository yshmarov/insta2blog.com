require 'test_helper'

class InstaCarouselJobTest < ActiveJob::TestCase
  def setup
    @insta_user = InstaUser.create(username: 'za.yuliia', remote_id: SecureRandom.random_number(9999))
    @insta_post = InstaPost.create(insta_user: @insta_user,
                                   media_type: :carousel_album,
                                   remote_id: SecureRandom.random_number(9999))
  end

  test 'should perform job' do
    assert_enqueued_jobs 0
    InstaCarouselJob.perform_later(@insta_post)
    assert_enqueued_jobs 1
  end
end
