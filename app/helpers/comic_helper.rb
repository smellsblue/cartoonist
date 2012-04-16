module ComicHelper
  def comic_url(number)
    if preview?
      "/comic_admin/#{number}/preview"
    else
      "/#{number}"
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
      "/comic_admin/preview_random"
    else
      "/random"
    end
  end
end
