module ComicAdminHelper
  def lock_toggle_target
    if @comic.locked
      "unlock"
    else
      "lock"
    end
  end

  def lock_disabled
    if @comic.locked
      'disabled="disabled"'.html_safe
    end
  end
end
