module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :announcements, :url => "/announcements"
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
  end
end
