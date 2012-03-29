Cartoonist::Application.routes.draw do
  root :to => "comic#current"
  match ":id", :controller => "comic", :action => "show", :id => /\d+/
  match "comic/:id.png", :controller => "comic", :action => "show", :id => /\d+/, :defaults => { :format => "png" }
  match "current" => "comic#current"
  match "random" => "comic#random"
  match "feed" => "comic#index", :defaults => { :format => "rss" }
  match "favicon" => "site#favicon", :defaults => { :format => "ico" }
  match "sitemap" => "site#sitemap", :defaults => { :format => "xml" }
  match "robots" => "site#robots", :defaults => { :format => "text" }

  resources :cache do
    collection do
      post "expire_www"
      post "expire_m"
      post "expire_tmp"
      post "expire_all"
    end
  end

  resources :admin do
    collection do
      get "cache_cron"
      get "backup"
      get "logout"
      get "main"
      get "reload"
      get "sign_in"
      post "sign_in"
      get "tweet_cron"
    end
  end

  resources :blog do
    collection do
      get "archives"
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

  resources :page_admin do
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

  match ":id", :controller => "page", :action => "show"
end
