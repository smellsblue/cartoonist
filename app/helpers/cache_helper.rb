module CacheHelper
  def td_cache_class(test)
    if test
      "cached"
    else
      "not-cached"
    end
  end

  def td_cache_text(test)
    if test
      "cached"
    else
      "not cached"
    end
  end
end
