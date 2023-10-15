# insta_post = InstaPost.first
# result = ProcessCaptionJob.perform_now(insta_post)
class ProcessCaptionJob < ApplicationJob
  queue_as :default

  delegate :link_to, to: 'ActionController::Base.helpers'

  include Rails.application.routes.url_helpers

  def perform(insta_post)
    @insta_post = insta_post
    return if @insta_post.caption.blank?

    processed_caption = with_regex(@insta_post.caption)
    @insta_post.reload
    @insta_post.update!(processed_caption:)
  end

  private

  def with_regex(text)
    regex = /#\w+/
    css_class = 'hashtag font-semibold'
    regex_to_link(text, regex, css_class)

    regex = /@\w+/
    css_class = 'mention font-semibold'
    regex_to_link(text, regex, css_class)
  end

  def regex_to_link(text, regex, css_class)
    results = text.scan(regex)
    results.flatten.each do |result|
      result_link =
        link_to result,
                insta_user_posts_path(@insta_post.insta_user, caption: result, onlypath: true),
                data: { turbo: false },
                class: css_class
      text.gsub!(result, result_link)
    end
    text
  end
end
