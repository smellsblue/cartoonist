require "spec_helper"

describe "Themes and Assets" do
  before do
    Cartoonist::Asset.class_variable_set :@@all, []
    Cartoonist::Asset.class_variable_set :@@included_js, []
    Cartoonist::Theme.class_variable_set :@@all, []
    Cartoonist::Theme.class_variable_set :@@themes, {}
    Cartoonist::Theme.class_variable_set :@@assets, []
  end

  it "remembers added themes" do
    Cartoonist::Theme.add :test, :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png"
    Cartoonist::Theme[:test].should == { :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png" }
  end

  it "remembers the current theme" do
    Cartoonist::Theme.add :test, :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png"
    Setting.stub(:[]) { :test }
    Cartoonist::Theme.current.should == { :css => "test.css", :favicon => "favicon.ico", :rss_logo => "logo.png" }
    Cartoonist::Theme.css.should == "test.css"
    Cartoonist::Theme.favicon.should == "favicon.ico"
    Cartoonist::Theme.rss_logo.should == "logo.png"
  end

  it "orders loaded themes" do
    Cartoonist::Theme.add :test1, :css => "test1.css", :favicon => "favicon1.ico", :rss_logo => "logo1.png"
    Cartoonist::Theme.add :test3, :css => "test3.css", :favicon => "favicon3.ico", :rss_logo => "logo3.png"
    Cartoonist::Theme.add :test2, :css => "test2.css", :favicon => "favicon2.ico", :rss_logo => "logo2.png"
    Cartoonist::Theme.all.should == [:test1, :test2, :test3]
  end

  it "adds assets when they are added via the theme" do
    Cartoonist::Theme.add_assets "test.css", "images/favicon.ico", "images/logo.png"
    Cartoonist::Asset.all.should == ["test.css", "images/favicon.ico", "images/logo.png"]
  end

  it "doesn't add duplicate assets" do
    Cartoonist::Theme.add_assets "test.css", "test.css"
    Cartoonist::Theme.add_assets "test.css"
    Cartoonist::Asset.all.should == ["test.css"]
  end

  it "remembers included js files" do
    Cartoonist::Asset.include_js "test1.js", "test2.js"
    Cartoonist::Asset.included_js.should == ["test1.js", "test2.js"]
  end

  it "doesn't add included js files to the all list" do
    Cartoonist::Asset.include_js "test1.js", "test2.js"
    Cartoonist::Asset.all.should == []
  end

  it "doesn't add duplicate included js files" do
    Cartoonist::Asset.include_js "test1.js", "test1.js"
    Cartoonist::Asset.include_js "test1.js"
    Cartoonist::Asset.included_js.should == ["test1.js"]
  end

  it "indicates no included js when nothing was included" do
    Cartoonist::Asset.included_js?.should == false
  end

  it "indicates included js when something was included" do
    Cartoonist::Asset.include_js "test1.js"
    Cartoonist::Asset.included_js?.should == true
  end
end
