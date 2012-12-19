class Admin::AnnouncementsController < AdminCartoonistController
  def new
  end

  def create
    announcement = Announcement.create_announcement params
    redirect_to "/admin/announcements/#{announcement.id}/edit"
  end

  def edit
    @announcement = Announcement.find params[:id].to_i
  end

  def update
    announcement = Announcement.update_announcement params
    redirect_to "/admin/announcements/#{announcement.id}/edit"
  end

  def index
    @unposted = Announcement.future.all
    @active = Announcement.active.all
    @expired = Announcement.expired.all
  end

  def lock
    announcement = Announcement.find params[:id].to_i
    announcement.lock!
    redirect_to "/admin/announcements/#{announcement.id}/edit"
  end

  def unlock
    announcement = Announcement.find params[:id].to_i
    announcement.unlock!
    redirect_to "/admin/announcements/#{announcement.id}/edit"
  end

  def preview_content
    render :text => Markdown.render(params[:content]), :layout => false
  end
end
