module CartoonistNotifications
  class Engine < ::Rails::Engine
    Cartoonist::Asset.include_js "cartoonist-notifications.js"
  end
end
