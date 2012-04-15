class SitemapEntry < Struct.new(:path, :lastmod, :changefreq, :priority)
  def formatted_lastmod
    lastmod.strftime "%Y-%m-%d"
  end
end
