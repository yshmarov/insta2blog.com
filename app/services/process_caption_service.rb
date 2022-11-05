# post = InstaPost.first
# result = ProcessCaptionService.new(post).call
class ProcessCaptionService
  delegate :link_to, to: 'ActionController::Base.helpers'
  # delegate :insta_user_posts_path, to: 'Rails.application.routes.url_helpers'

  include Rails.application.routes.url_helpers

  attr_reader :post

  def initialize(post)
    @post = post
  end

  def call
    return if post.caption.blank?

    processed_caption = with_regex(post.caption)
    post.update!(processed_caption:)
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
                insta_user_posts_path(post.insta_user, caption: result, onlypath: true),
                data: { turbo: false },
                class: css_class
      text.gsub!(result, result_link)
    end
    text
  end
end
