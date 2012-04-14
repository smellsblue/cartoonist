Cartoonist::Application.routes.draw do
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

  resources :static_cache, :constraints => { :id => /.*/ } do
    collection do
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

  resources :settings do
    collection do
      get "initial_setup"
      post "save_initial_setup"
    end
  end

  Cartoonist::Routes.load! self
end
