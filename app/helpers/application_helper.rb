module ApplicationHelper
  def with_hashtags(text)
    return nil if text.blank?

    text.gsub(/\S*#(\[[^\]]+\]|\S+)/, '<a href="http://localhost:3000/u/za-yuliia/p?caption=\1" class="hashtag">#\1</a>')
  end
end
