class Admin::AnnouncementsController < AdminCartoonistController
  def index
    @unposted = Announcement.future.all
    @active = Announcement.active.all
    @expired = Announcement.expired.all
  end
end
