module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :announcements, :url => "/announcements_admin"
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
    Cartoonist::Migration.add_for self
    Cartoonist::Backup.for :announcements do
      Announcement.order(:id).all
    end
    Cartoonist::Routes.add do
      resources :announcements
      resources :announcements_admin
    end
  end
end
