require "RMagick"

class Comic < ActiveRecord::Base
  include Postable
  include Entity
  include Lockable
  entity_type :comic
  entity_global_url "/comic"
  entity_url &:url
  entity_preview_url &:preview_url
  entity_edit_url &:edit_url
  entity_description &:title
  belongs_to :database_file
  belongs_to :site

  def preview_url
    "/admin/comic/#{number}/preview"
  end

  def url
    "/comic/#{number}"
  end

  def edit_url
    "/admin/comic/#{number}/edit"
  end

  def formatted_description
    Markdown.render description
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

  def magick
    return @magick if @magick
    images = Magick::Image.from_blob database_file.content
    raise "Only 1 image is allowed!" if images.size != 1
    @magick = images.first
  end

  def img_width
    magick.columns
  end

  def img_height
    magick.rows
  end

  def img_url
    "/comic/#{number}.png"
  end

  def preview_img_url
    "/admin/comic/#{number}/preview.png"
  end

  def absolute_img_url
    "http://#{site.settings[:domain]}#{img_url}"
  end

  class << self
    SUNDAY = 0
    MONDAY = 1
    TUESDAY = 2
    WEDNESDAY = 3
    THURSDAY = 4
    FRIDAY = 5
    SATURDAY = 6

    DAY_CONVERSION = {
      :sunday => SUNDAY,
      :monday => MONDAY,
      :tuesday => TUESDAY,
      :wednesday => WEDNESDAY,
      :thursday => THURSDAY,
      :friday => FRIDAY,
      :saturday => SATURDAY
    }

    def search(query)
      reverse_numerical.where "LOWER(title) LIKE :query OR LOWER(description) LIKE :query OR LOWER(scene_description) LIKE :query OR LOWER(dialogue) LIKE :query OR LOWER(title_text) LIKE :query", :query => "%#{query.downcase}%"
    end

    def create_comic(site, params)
      last = current_created
      create :number => next_number(last), :title => params[:title], :posted_at => next_post_date(site, last), :description => params[:description], :scene_description => params[:scene_description], :dialogue => params[:dialogue], :title_text => params[:title_text], :database_file => DatabaseFile.create_from_param(params[:image], :allowed_extensions => ["png"]), :locked => true
    end

    def update_comic(params)
      comic = from_number params[:id].to_i
      comic.ensure_unlocked!
      comic.title = params[:title]
      comic.description = params[:description]
      comic.scene_description = params[:scene_description]
      comic.dialogue = params[:dialogue]
      comic.title_text = params[:title_text]
      comic.locked = true
      comic.database_file = DatabaseFile.create_from_param params[:image], :allowed_extensions => ["png"] if params[:image]
      comic.save!
      comic
    end

    def next_number(comic)
      if comic
        comic.number + 1
      else
        1
      end
    end

    def next_post_date(site, comic)
      if comic
        from = comic.posted_at
      else
        from = Date.today
      end

      valid_days = site.settings[:schedule].map { |x| DAY_CONVERSION[x] }

      result = from
      result += 1.day until result > from && valid_days.include?(result.wday)
      result
    end

    def largest_posted_number
      current.number
    end

    def largest_number
      preview_current.number
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
      posted.reverse_numerical.to_a
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
