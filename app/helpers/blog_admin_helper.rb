module BlogAdminHelper
  def lock_toggle_target
    if @post.locked
      "unlock"
    else
      "lock"
    end
  end

  def lock_disabled
    if @post.locked
      'disabled="disabled"'.html_safe
    end
  end

  def post_lock_disabled
    if @post.locked || @post.posted?
      'disabled="disabled"'.html_safe
    end
  end

  def format_posted_at(fmt)
    if @post && @post.posted_at
      @post.posted_at.localtime.strftime fmt
    end
  end
end
