class AnnouncementsAdminController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @unposted = Announcement.future.all
    @active = Announcement.active.all
    @expired = Announcement.expired.all
  end
end
