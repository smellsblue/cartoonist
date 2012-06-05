module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :announcements, :url => "/admin/announcements"
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
    Cartoonist::Migration.add_for self
    Cartoonist::Backup.for :announcements do
      Announcement.order(:id)
    end
    Cartoonist::Routes.add do
      resources :announcements

      namespace :admin do
        resources :announcements
      end
    end
  end
end
