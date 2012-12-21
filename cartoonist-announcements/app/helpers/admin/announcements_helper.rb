module Admin::AnnouncementsHelper
  def lock_disabled
    @announcement.lock_disabled_html
  end
end
