module CartoonistAnnouncements
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :announcements, :url => "/admin/announcements"
    Cartoonist::Asset.include_js "cartoonist-announcements.js"
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :announcements do
      Announcement.order(:id)
    end

    Cartoonist::Routes.add do
      resources :announcements, :only => []

      namespace :admin do
        resources :announcements, :only => [:new, :create, :edit, :update, :index] do
          member do
            post "lock"
            post "unlock"
          end

          collection do
            post "preview_content"
          end
        end
      end
    end
  end
end
