class AdminController < CartoonistController
  before_filter :ensure_ssl!, :except => [:cron]
  before_filter :check_admin!, :except => [:cron]

  def show
    redirect_to "/admin/main"
  end

  def backup
    respond_to do |format|
      format.html { redirect_to "/admin/main" }

      format.zip do
        prefix = "dev-" unless Rails.env.production?
        filename = "#{prefix}cartoonist-backup-#{Time.now.strftime("%Y-%m-%d_%H%M%S")}.zip"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

        self.response_body = Enumerator.new do |out|
          buffer = Zip::ZipOutputStream.write_buffer do |zos|
            Backup.each do |entry|
              zos.put_next_entry entry.path
              zos.write entry.content
            end
          end

          out << buffer.string
        end
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

  def cron
    Cartoonist::Cron.all.each &:call
    render :text => "Success.", :layout => false
  rescue => e
    logger.error "Failure running cron: #{e}\n  #{e.backtrace.join "\n  "}"
    render :text => "Failure.", :layout => false
  end
end
