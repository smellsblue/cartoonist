Rails.application.config.to_prepare do
  Cartoonist::Backup.for :comics do
    Comic.order(:id).all
  end

  Cartoonist::Backup.for :files do
    DatabaseFile.order(:id).all
  end

  Cartoonist::Backup.for :blog_posts do
    BlogPost.order(:id).all
  end

  Cartoonist::Backup.for :pages do
    Page.order(:id).all
  end

  Cartoonist::Backup.for :settings do
    Setting.order(:id).all
  end
end
