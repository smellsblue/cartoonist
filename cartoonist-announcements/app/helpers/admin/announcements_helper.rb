module Admin::AnnouncementsHelper
  def lock_toggle_target
    if @announcement.locked
      "unlock"
    else
      "lock"
    end
  end

  def lock_disabled
    if @announcement.locked
      'disabled="disabled"'.html_safe
    end
  end
end
