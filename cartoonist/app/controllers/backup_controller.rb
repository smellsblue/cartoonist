class BackupController < AdminCartoonistController
  include ActionController::Live

  def backup
    respond_to do |format|
      format.html { redirect_to "/admin/main" }

      format.tgz do
        Backup.new(:tgz).stream_to response
      end

      format.zip do
        Backup.new(:zip).stream_to response
      end
    end
  end
end
