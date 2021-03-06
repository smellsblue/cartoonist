module CartoonistBlog
  class Engine < ::Rails::Engine
    Cartoonist::Asset.add "admin/blog.css"
    Cartoonist::Asset.add "admin/blog.js"
    Cartoonist::Entity.add :blog, "BlogPost"
    Cartoonist::Admin::Tab.add :blog, :url => "/admin/blog", :order => 1
    Cartoonist::RootPath.add :blog, "blog#index"
    Cartoonist::Navigation::Link.add :url => "/blog", :preview_url => "/admin/blog/preview", :class => "blog", :label => "cartoonist.layout.navigation.blog", :order => 1
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :blog_posts do
      BlogPost.order(:id)
    end

    Cartoonist::Sitemap.add do
      posts = BlogPost.sitemap

      result = posts.map do |post|
        SitemapEntry.new "/blog/#{post.url_title}", post.posted_at, :never
      end

      unless result.empty?
        first = posts.first
        result << SitemapEntry.new("/blog", first.posted_at, :weekly, "0.9")
      end

      result
    end

    Cartoonist::Routes.add do
      resources :blog, :only => [:index, :show] do
        collection do
          get "archives"
          get "feed", :defaults => { :format => "rss" }
        end
      end

      namespace :admin do
        resources :blog, :only => [:create, :edit, :index, :new, :update] do
          member do
            post "lock"
            get "preview"
            post "unlock"
          end

          collection do
            get "archives"
            get "preview"
            post "preview_content"
          end
        end
      end
    end
  end
end
