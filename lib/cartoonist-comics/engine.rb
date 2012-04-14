module CartoonistComics
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :comics, :url => "/comic_admin", :order => 0
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :comics do
      Comic.order(:id).all
    end

    Cartoonist::Routes.add_begin do
      root :to => "comic#current"
      match ":id", :controller => "comic", :action => "show", :id => /\d+/
    end

    Cartoonist::Routes.add do
      match "comic/:id.png", :controller => "comic", :action => "show", :id => /\d+/, :defaults => { :format => "png" }
      match "current" => "comic#current"
      match "random" => "comic#random"
      match "feed" => "comic#index", :defaults => { :format => "rss" }

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
