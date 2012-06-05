source "http://rubygems.org"

gem "rails"

group :development, :test do
  gem "sqlite3-ruby", :require => "sqlite3"
end

group :assets do
  gem "sass-rails"
  gem "uglifier"
  gem "therubyracer"
end

group :production do
  gem "passenger"

  # This can be swapped out for a real database, if you are
  # comfortable setting it up.
  gem "sqlite3-ruby", :require => "sqlite3"
end

gem "jquery-rails"

group :test do
  gem "rspec-rails", :require => false
  gem "turn", "0.8.2", :require => false
end

gem "cartoonist"
gem "cartoonist-default-theme"
gem "cartoonist-comics"
gem "cartoonist-blog"
gem "cartoonist-pages"
gem "cartoonist-announcements"
