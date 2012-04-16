class Comic < ActiveRecord::Base
  belongs_to :database_file
  include Tweetable

  def expected_tweet_time
    Time.local posted_at.year, posted_at.month, posted_at.day, 8, 0
  end

  def formatted_posted_at(default_msg = "not yet posted")
    if posted_at
      posted_at.strftime "%-m/%-d/%Y"
    else
      default_msg
    end
  end

  def real?
    number
  end

  def previous_number
    if number
      number - 1
    end
  end

  def next_number
    if number
      number + 1
    end
  end

  def oldest?
    number == 1 || !number
  end

  def maybe_newest?
    if respond_to? :max_number
      max_number.to_i == number
    end
  end

  def absolute_url
    "http://#{Setting[:domain]}/#{number}"
  end

  def img_url
    "/comic/#{number}.png"
  end

  def preview_img_url
    "/comic_admin/#{number}/preview.png"
  end

  def absolute_img_url
    "http://#{Setting[:domain]}#{img_url}"
  end

  class << self
    MONDAY = 1
    WEDNESDAY = 3
    FRIDAY = 5

    VALID_DAYS = [MONDAY, WEDNESDAY, FRIDAY]

    def next_number(comic)
      if comic
        comic.number + 1
      else
        1
      end
    end

    def next_post_date(comic)
      if comic
        from = comic.posted_at
      else
        from = Date.today
      end

      result = from
      result += 1.day until result > from && VALID_DAYS.include?(result.wday)
      result
    end

    def largest_posted_number
      current.number
    end

    def largest_number
      preview_current.number
    end

    def untweeted
      posted.where(:tweeted_at => nil).all
    end

    def posted
      where "comics.posted_at <= ?", Date.today
    end

    def unposted
      where "comics.posted_at > ?", Date.today
    end

    def reverse_numerical
      order "comics.number DESC"
    end

    def numerical
      order "comics.number ASC"
    end

    def feed
      posted.reverse_numerical.take 10
    end

    def sitemap
      posted.reverse_numerical.all
    end

    def current_created
      reverse_numerical.first
    end

    def current
      comic = posted.reverse_numerical.first
      comic = new :title => "No Comics Yet", :description => "Check back later for the first comic!" unless comic
      comic
    end

    def preview_current
      comic = reverse_numerical.first
      comic = new :title => "No Comics Yet", :description => "Check back later for the first comic!" unless comic
      comic
    end

    def from_number(num, only_posted = false)
      comic = where :number => num.to_i

      if only_posted
        max_number = Comic.posted.select("MAX(comics.number)").to_sql
        comic = comic.posted.select("comics.*, (#{max_number}) AS max_number")
      else
        max_number = Comic.select("MAX(comics.number)").to_sql
        comic = comic.select("comics.*, (#{max_number}) AS max_number")
      end

      comic = comic.first
      raise ActiveRecord::RecordNotFound.new("No records found!") unless comic
      comic
    end
  end
end
