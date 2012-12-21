module Admin::PageHelper
  def lock_disabled
    @page.lock_disabled_html
  end

  def format_posted_at(fmt)
    if @page && @page.posted_at
      @page.posted_at.to_time.strftime fmt
    else
      "not yet posted"
    end
  end
end
