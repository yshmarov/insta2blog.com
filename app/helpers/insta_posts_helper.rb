module InstaPostsHelper
  def with_regex(post)
    regex = /#\w+/
    css_class = 'hashtag'
    regex_to_link(post, regex, css_class)

    regex = /@\w+/
    css_class = 'mention'
    regex_to_link(post, regex, css_class)
  end

  def regex_to_link(post, regex, css_class)
    return nil if post.caption.blank?

    body = post.caption
    hashtags = body.scan(regex)
    hashtags.flatten.each do |hashtag|
      hashtag_link =
        link_to hashtag,
                insta_user_posts_path(post.insta_user, caption: hashtag),
                data: { turbo: false },
                class: css_class
      body.gsub!(hashtag, hashtag_link)
    end
    body
  end
end
