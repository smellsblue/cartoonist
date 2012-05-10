module Admin::PageHelper
  def lock_toggle_target
    if @page.locked
      "unlock"
    else
      "lock"
    end
  end

  def lock_disabled
    if @page.locked
      'disabled="disabled"'.html_safe
    end
  end

  def format_posted_at(fmt)
    if @page && @page.posted_at
      @page.posted_at.to_time.strftime fmt
    else
      "not yet posted"
    end
  end
end
