module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :announcements, :url => "/announcements_admin"
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
    Cartoonist::Migration.add_dirs self.paths["db/migrate"].existent
    Cartoonist::Routes.add do
      resources :announcements
      resources :announcements_admin
    end
  end
end
