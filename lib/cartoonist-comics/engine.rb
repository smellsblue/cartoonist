module CartoonistComics
  class Engine < ::Rails::Engine
    Cartoonist::Entity.add :comic, "Comic"
    Cartoonist::Admin::Tab.add :comics, :url => "/admin/comic", :order => 0
    Cartoonist::RootPath.add :comics, "comic#index"
    Cartoonist::Navigation::Link.add :url => "/comic", :preview_url => "/admin/comic/preview", :class => "comic", :label => "cartoonist.layout.navigation.comic", :order => 0
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :comics do
      Comic.order(:id).all
    end

    Cartoonist::Sitemap.add do
      comics = Comic.sitemap

      result = comics.map do |comic|
        SitemapEntry.new "/comic/#{comic.number}", comic.posted_at, :never
      end

      unless result.empty?
        first = comics.first
        result << SitemapEntry.new("/comic", first.posted_at, :daily, "1.0")
      end

      result
    end

    Cartoonist::Routes.add do
      resources :comic do
        collection do
          get "random"
          get "feed", :defaults => { :format => "rss" }
        end
      end

      namespace :admin do
        resources :comic do
          member do
            post "lock"
            get "preview"
            post "unlock"
          end

          collection do
            get "preview"
            get "preview_random"
          end
        end
      end
    end
  end
end
