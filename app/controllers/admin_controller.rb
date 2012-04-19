class AdminController < CartoonistController
  before_filter :ensure_ssl!, :except => [:cache_cron, :tweet_cron]
  before_filter :check_admin!, :except => [:cache_cron, :tweet_cron]

  def index
    redirect_to "/admin/main"
  end

  def backup
    respond_to do |format|
      format.html { redirect_to "/admin/main" }
      format.json do
        prefix = "dev-" unless Rails.env.production?
        filename = "#{prefix}comics-backup-#{Time.now.strftime("%Y-%m-%d_%H%M%S")}.json"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
        render :text => Backup.all.to_json, :content_type => "application/json"
      end
    end
  end

  def reload
    if Rails.env.production?
      %x[git pull]
      %x[touch #{File.join Rails.root, "tmp/restart.txt"}]
      flash[:message] = "Updated and restarted."
    end

    redirect_to "/admin/main"
  end

  def main
    render :layout => "general_admin"
  end

  def cache_cron
    Dir.glob(File.join(Rails.root, "public/cache/**/*.tmp.html*"), File::FNM_DOTMATCH).each do |file|
      if 2.hours.ago > File.mtime(file)
        File.delete file
      end
    end

    render :text => "Success.", :layout => false
  rescue
    render :text => "Failure.", :layout => false
  end

  def tweet_cron
    messages = []

    Comic.untweeted.each do |comic|
      comic.tweet!
      messages << "Comic: #{comic.tweet}"
    end

    BlogPost.untweeted.each do |post|
      post.tweet!
      messages << "Blog Post: #{post.tweet}"
    end

    unless Rails.env.production?
      content = "#{messages.join "\n"}\n"
    end

    render :text => "#{content}Success.", :layout => false
  rescue
    render :text => "Failure.", :layout => false
  end
end
