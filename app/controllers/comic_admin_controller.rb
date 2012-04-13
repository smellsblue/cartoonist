class ComicAdminController < ApplicationController
  before_filter :preview!, :only => [:preview, :preview_random]
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @unposted = Comic.unposted.numerical
    @posted = Comic.posted.reverse_numerical
  end

  def preview
    respond_to do |format|
      format.html do
        if params[:id].present?
          begin
            return redirect_to "/comic_admin/1/preview" if params[:id].to_i < 1
            @comic = Comic.from_number params[:id]
            @disabled_next = @comic.maybe_newest?
          rescue
            return redirect_to "/comic_admin/preview"
          end
        else
          @comic = Comic.preview_current
          @disabled_next = true
        end

        @disabled_prev = true if @comic.oldest?
        render "comic/show", :layout => "comic"
      end

      format.png do
        comic = Comic.from_number params[:id]
        send_data comic.database_file.content, :filename => "comic_#{comic.number}.png", :type => "image/png", :disposition => "inline"
      end
    end
  end

  def preview_random
    redirect_to "/comic_admin/#{rand(max_preview_comic) + 1}/preview"
  end

  def new
    last = Comic.current_created
    @next_number = Comic.next_number last
    @next_post_date = Comic.next_post_date last
    @edit_last_number = last.number if last
  end

  def create
    unless params[:image]
      flash[:message] = "Error: You must include an image when creating a new comic."
      return redirect_to "/comic_admin/new"
    end

    last = Comic.current_created
    comic_number = Comic.next_number last
    comic = Comic.create :number => comic_number, :title => params[:title], :posted_at => Comic.next_post_date(last), :description => params[:description], :scene_description => params[:scene_description], :dialogue => params[:dialogue], :title_text => params[:title_text], :tweet => params[:tweet], :database_file => DatabaseFile.create(:content => params[:image].read), :locked => true
    redirect_to "/comic_admin/#{comic.number}/edit"
  end

  def edit
    @comic = Comic.from_number params[:id]
    @edit_last_number = @comic.number - 1
    @edit_next_number = @comic.number + 1
  rescue ActiveRecord::RecordNotFound
    redirect_to "/comic_admin/new"
  end

  def lock
    comic = Comic.from_number params[:id].to_i
    comic.locked = true
    comic.save!
    redirect_to "/comic_admin/#{comic.number}/edit"
  end

  def unlock
    comic = Comic.from_number params[:id].to_i
    comic.locked = false
    comic.save!
    redirect_to "/comic_admin/#{comic.number}/edit"
  end

  def update
    comic_number = params[:id].to_i
    comic = Comic.from_number comic_number
    raise "Cannot update locked comic!" if comic.locked
    comic.title = params[:title]
    comic.description = params[:description]
    comic.scene_description = params[:scene_description]
    comic.dialogue = params[:dialogue]
    comic.title_text = params[:title_text]
    comic.tweet = params[:tweet] unless comic.tweeted?
    comic.locked = true
    comic.database_file = DatabaseFile.create(:content => params[:image].read) if params[:image]
    comic.save!
    redirect_to "/comic_admin/#{comic.number}/edit"
  end

  private
  def admin_comic_cache
    @@admin_comic_cache ||= ActiveSupport::Cache::MemoryStore.new(:expires_in => 2.hours)
  end

  def max_preview_comic
    result = admin_comic_cache.read "preview-max-comic"
    return result if result
    result = Comic.largest_number
    admin_comic_cache.write "preview-max-comic", result
    result
  end
end
