module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
  end
end
