class Comic < ActiveRecord::Base
  include Postable
  include Entity
  entity_type :comic
  entity_global_url "/comic"
  entity_url &:url
  entity_preview_url &:preview_url
  entity_edit_url &:edit_url
  entity_description &:title
  attr_accessible :number, :posted_at, :title, :description, :scene_description, :dialogue, :title_text, :database_file_id, :database_file, :locked
  belongs_to :database_file

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

  def lock!
    self.locked = true
    save!
  end

  def unlock!
    self.locked = false
    save!
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

  def img_url
    "/comic/#{number}.png"
  end

  def preview_img_url
    "/admin/comic/#{number}/preview.png"
  end

  def absolute_img_url
    "http://#{Setting[:domain]}#{img_url}"
  end

  class << self
    MONDAY = 1
    WEDNESDAY = 3
    FRIDAY = 5

    VALID_DAYS = [MONDAY, WEDNESDAY, FRIDAY]

    def create_comic(params)
      last = current_created
      create :number => next_number(last), :title => params[:title], :posted_at => next_post_date(last), :description => params[:description], :scene_description => params[:scene_description], :dialogue => params[:dialogue], :title_text => params[:title_text], :database_file => DatabaseFile.create_from_param(params[:image], :allowed_extensions => ["png"]), :locked => true
    end

    def update_comic(params)
      comic = from_number params[:id].to_i
      raise "Cannot update locked comic!" if comic.locked
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