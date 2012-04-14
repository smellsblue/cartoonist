Rails.application.config.to_prepare do
  Cartoonist::Admin::Tab.add :general, :url => "/admin", :order => 3
end
