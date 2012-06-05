module Admin::CacheHelper
  def td_cache_class(test)
    if test
      "cached"
    else
      "not-cached"
    end
  end

  def td_cache_text(test)
    if test
      t "cach.index.cached"
    else
      t "cach.index.not_cached"
    end
  end
end
