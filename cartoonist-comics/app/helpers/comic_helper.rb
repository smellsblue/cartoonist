module ComicHelper
  def comic_current_url
    if preview?
      "/admin/comic/preview"
    else
      "/comic"
    end
  end

  def comic_url(number)
    if preview?
      "/admin/comic/#{number}/preview"
    else
      "/comic/#{number}"
    end
  end

  def comic_img_url
    if preview?
      @comic.preview_img_url
    else
      @comic.img_url
    end
  end

  def random_url
    if preview?
      "/admin/comic/preview_random"
    else
      "/comic/random"
    end
  end
end
