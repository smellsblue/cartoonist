module CartoonistDefaultTheme
  CSS = "cartoonist-default-theme.css"
  FAVICON = "cartoonist-default-theme/favicon.ico"
  LOGO = "cartoonist-default-theme/logo.png"

  class Engine < ::Rails::Engine
    CartoonistThemes.add :cartoonist_default_theme, :css => CSS, :favicon => FAVICON, :rss_logo => LOGO
    CartoonistThemes.add_assets CSS, "images/#{FAVICON}", "images/#{LOGO}"
  end
end
