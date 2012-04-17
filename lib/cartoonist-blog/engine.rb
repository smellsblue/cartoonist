module CartoonistBlog
  class Engine < ::Rails::Engine
    Cartoonist::Admin::Tab.add :blog, :url => "/blog_admin", :order => 1
    Cartoonist::RootPath.add :blog, "blog#index"
    Cartoonist::Navigation::Link.add :url => "/blog", :preview_url => "/blog_admin/preview", :class => "blog", :label => "application.layout.navigation.blog", :order => 1
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :blog_posts do
      BlogPost.order(:id).all
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
