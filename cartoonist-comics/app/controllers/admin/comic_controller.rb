class Admin::ComicController < AdminCartoonistController
  helper :comic
  before_filter :preview!, :only => [:preview, :preview_random]

  def index
    @unposted = Comic.unposted.numerical
    @posted = Comic.posted.reverse_numerical
  end

  def preview
    respond_to do |format|
      format.html do
        if params[:id].present?
          begin
            return redirect_to "/admin/comic/1/preview" if params[:id].to_i < 1
            @comic = Comic.from_number params[:id]
            @disabled_next = @comic.maybe_newest?
          rescue
            return redirect_to "/admin/comic/preview"
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
    redirect_to "/admin/comic/#{rand(max_preview_comic) + 1}/preview"
  end

  def new
    last = Comic.current_created
    @next_number = Comic.next_number last
    @next_post_date = Comic.next_post_date @this_site, last
    @edit_last_number = last.number if last
  end

  def create
    unless params[:image]
      flash[:message] = "Error: You must include an image when creating a new comic."
      return redirect_to "/admin/comic/new"
    end

    comic = Comic.create_comic @this_site, params
    redirect_to "/admin/comic/#{comic.number}/edit"
  end

  def edit
    @comic = Comic.from_number params[:id]
    @edit_last_number = @comic.number - 1
    @edit_next_number = @comic.number + 1
  rescue ActiveRecord::RecordNotFound
    redirect_to "/admin/comic/new"
  end

  def lock
    comic = Comic.from_number params[:id].to_i
    comic.lock!
    redirect_to "/admin/comic/#{comic.number}/edit"
  end

  def unlock
    comic = Comic.from_number params[:id].to_i
    comic.unlock!
    redirect_to "/admin/comic/#{comic.number}/edit"
  end

  def update
    comic = Comic.update_comic params
    redirect_to "/admin/comic/#{comic.number}/edit"
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
