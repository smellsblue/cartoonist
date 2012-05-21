class ComicFeed
  attr_reader :pub_date, :items

  def initialize(feed)
    first = feed.first

    if first
      first_date = first.posted_at
    else
      first_date = Date.today
    end

    @pub_date = first_date.to_time.strftime "%a, %d %b %Y 00:00:01 %z"
    @items = feed.map do |item|
      ComicFeed::Item.new item
    end
  end

  class Item
    attr_reader :number, :title, :img_url, :title_text, :description, :pub_date

    def initialize(comic)
      @number = comic.number
      @title = comic.title
      @img_url = comic.absolute_img_url
      @title_text = comic.title_text
      @description = comic.formatted_description
      @pub_date = comic.posted_at.to_time.strftime "%a, %d %b %Y 00:00:01 %z"
    end
  end
end
