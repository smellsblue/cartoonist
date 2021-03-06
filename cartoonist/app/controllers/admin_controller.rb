class AdminController < AdminCartoonistController
  skip_before_filter :ensure_ssl!, :only => [:cron]
  skip_before_filter :check_admin!, :only => [:cron]

  def show
    redirect_to "/admin/main"
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

  def cron
    Cartoonist::Cron.all.each &:call
    render :text => "Success.", :layout => false
  rescue => e
    logger.error "Failure running cron: #{e}\n  #{e.backtrace.join "\n  "}"
    render :text => "Failure.", :layout => false
  end
end
