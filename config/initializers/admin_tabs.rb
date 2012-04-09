Rails.application.config.to_prepare do
  Cartoonist::Admin::Tab.add :comics, "/comic_admin"
  Cartoonist::Admin::Tab.add :blog_posts, "/blog_admin"
  Cartoonist::Admin::Tab.add :pages, "/page_admin"
  Cartoonist::Admin::Tab.add :general, "/admin"
end
