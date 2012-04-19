class BlogFeed
  attr_reader :pub_date, :items

  def initialize(feed)
    first = feed.first

    if first
      first_date = first.posted_at
    else
      first_date = Time.now
    end

    @pub_date = first_date.localtime.strftime "%a, %d %b %Y %H:%M:00 %z"
    @items = feed.map do |item|
      BlogFeed::Item.new item
    end
  end

  class Item
    attr_reader :title, :content, :url_title, :pub_date

    def initialize(post)
      @title = post.title
      @content = Markdown.render post.content, false
      @url_title = post.url_title
      @pub_date = post.posted_at.localtime.strftime "%a, %d %b %Y %H:%M:00 %z"
    end
  end
end
