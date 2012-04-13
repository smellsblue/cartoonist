module CartoonistBlog
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :blog, :url => "/blog_admin", :order => 1
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :blog_posts do
      BlogPost.order(:id).all
    end

    Cartoonist::Routes.add do
      resources :blog do
        collection do
          get "archives"
          get "feed", :defaults => { :format => "rss" }
        end
      end

      resources :blog_admin do
        member do
          post "lock"
          get "preview"
          post "unlock"
        end

        collection do
          get "preview"
          post "preview_content"
        end
      end
    end
  end
end
