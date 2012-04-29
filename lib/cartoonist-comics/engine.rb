module CartoonistComics
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :comics, :url => "/comic_admin", :order => 0
    Cartoonist::RootPath.add :comics, "comic#index"
    Cartoonist::Navigation::Link.add :url => "/comic", :preview_url => "/comic_admin/preview", :class => "comic", :label => "cartoonist.layout.navigation.comic", :order => 0
    Cartoonist::Migration.add_for self
    Cartoonist::Entity.add :comic, :label => "cartoonist.entity.comic", :model_class => "Comic"

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

      resources :comic_admin do
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
