module CartoonistNotifications
  class Engine < ::Rails::Engine
    CartoonistAssets.include_js "cartoonist-notifications.js"
  end
end
