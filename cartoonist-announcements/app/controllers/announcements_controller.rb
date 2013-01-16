class AnnouncementsController < CartoonistController
  def index
    cache_page_as "announcements.#{cache_type}.tmp.json" do
      render :json => { :announcements => Announcement.actives_as_hash }
    end
  end
end
