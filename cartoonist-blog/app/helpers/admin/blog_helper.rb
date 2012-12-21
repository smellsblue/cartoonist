module Admin::BlogHelper
  def lock_disabled
    @post.lock_disabled_html
  end

  def post_lock_disabled
    if @post.locked? || @post.posted?
      'disabled="disabled"'.html_safe
    end
  end

  def format_posted_at(fmt)
    if @post && @post.posted_at
      @post.posted_at.localtime.strftime fmt
    end
  end
end
