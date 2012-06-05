module CartoonistPages
  class Engine < ::Rails::Engine
    Cartoonist::Entity.add :page, "Page"
    Cartoonist::Admin::Tab.add :pages, :url => "/admin/page", :order => 2
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :pages do
      Page.order(:id)
    end

    Cartoonist::Sitemap.add do
      Page.sitemap.map do |page|
        SitemapEntry.new page.entity_relative_url, page.posted_at, :monthly, "0.4"
      end
    end

    Cartoonist::Routes.add_end do
      match ":id", :controller => "page", :action => "show"
    end

    Cartoonist::Routes.add do
      namespace :admin do
        resources :page do
          member do
            post "lock"
            post "post"
            get "preview"
            post "unlock"
            post "unpost"
          end

          collection do
            post "preview_content"
          end
        end
      end
    end
  end
end
