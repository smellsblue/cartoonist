class AnnouncementsController < CartoonistController
  def index
    render :json => { :announcements => Announcement.actives_as_hash }
  end
end
