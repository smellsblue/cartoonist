module CartoonistSuggestions
  class Engine < ::Rails::Engine
    config.to_prepare do
      Setting::Tab.define :suggestions, :order => 3 do
        Setting::Section.define :page, :order => 1 do
          Setting.define :suggestion_prefix, :type => :text
        end
      end
    end

    Cartoonist::Navigation::Link.add :url => "/suggestions/new", :class => "suggest", :label => "cartoonist.layout.navigation.suggest", :order => 3
    Cartoonist::Admin::Tab.add :suggestions, :url => "/admin/suggestions"
    Cartoonist::Migration.add_for self
    Cartoonist::Searchable.add "Suggestion"

    Cartoonist::Backup.for :suggestions do
      Suggestion.order(:id)
    end

    Cartoonist::Sitemap.add do
      [SitemapEntry.new("/suggestions/new", Date.new(2012, 9, 21), :yearly, "0.2")]
    end

    Cartoonist::Routes.add do
      resources :suggestions, :only => [:new, :create]

      namespace :admin do
        resources :suggestions, :only => [:index, :show] do
          collection do
            post :toggle
          end

          member do
            post :toggle
          end
        end
      end
    end
  end
end
