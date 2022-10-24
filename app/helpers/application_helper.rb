module ApplicationHelper
  def with_hashtags(post)
    return nil if post.caption.blank?

    body = post.caption
    hashtags = body.scan(/#\w+/)
    hashtags.flatten.each do |hashtag|
      hashtag_link =
        link_to hashtag,
                insta_user_posts_path(post.insta_user, caption: hashtag),
                data: { turbo: false },
                class: 'hashtag'
      body.gsub!(hashtag, hashtag_link)
    end
    body
  end
end
