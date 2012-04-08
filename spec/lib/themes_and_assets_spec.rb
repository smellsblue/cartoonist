require "spec_helper"

describe "Themes and Assets" do
  before do
    CartoonistAssets.class_variable_set :@@all, []
    CartoonistThemes.class_variable_set :@@all, []
    CartoonistThemes.class_variable_set :@@themes, {}
    CartoonistThemes.class_variable_set :@@assets, []
  end

  it "remembers added themes" do
    CartoonistThemes.add :test, :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png"
    CartoonistThemes[:test].should == { :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png" }
  end

  it "remembers the current theme" do
    CartoonistThemes.add :test, :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png"
    Setting.stub(:[]) { :test }
    CartoonistThemes.current.should == { :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png" }
    CartoonistThemes.css.should == "test.css"
    CartoonistThemes.favicon.should == "favicon.ico"
    CartoonistThemes.rss_logo.should == "logo.png"
  end

  it "orders loaded themes" do
    CartoonistThemes.add :test1, :css => "test1.css", :favicon => "favicon1.ico", :rss_logo => "logo1.png"
    CartoonistThemes.add :test3, :css => "test3.css", :favicon => "favicon3.ico", :rss_logo => "logo3.png"
    CartoonistThemes.add :test2, :css => "test2.css", :favicon => "favicon2.ico", :rss_logo => "logo2.png"
    CartoonistThemes.all.should == [:test1, :test2, :test3]
  end

  it "adds assets when they are added via the theme" do
    CartoonistThemes.add_assets "test.css", "images/favicon.ico", "images/logo.png"
    CartoonistAssets.all.should == ["test.css", "images/favicon.ico", "images/logo.png"]
  end

  it "doesn't add duplicate assets" do
    CartoonistThemes.add_assets "test.css", "test.css"
    CartoonistThemes.add_assets "test.css"
    CartoonistAssets.all.should == ["test.css"]
  end
end
