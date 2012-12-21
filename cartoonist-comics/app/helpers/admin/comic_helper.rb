module Admin::ComicHelper
  def lock_disabled
    @comic.lock_disabled_html
  end
end
