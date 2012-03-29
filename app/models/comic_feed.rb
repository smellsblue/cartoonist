class ComicFeed
  attr_reader :pub_date, :items

  def initialize(feed)
    @pub_date = feed.first.posted_at.to_time.strftime "%a, %d %b %Y 00:00:01 %z"
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
      @description = comic.description
      @pub_date = comic.posted_at.to_time.strftime "%a, %d %b %Y 00:00:01 %z"
    end
  end
end
