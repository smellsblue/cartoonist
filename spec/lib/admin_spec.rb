require "spec_helper"

describe "Admin plugin interface" do
  before do
    Cartoonist::Admin::Tab.class_variable_set :@@all, []
    Cartoonist::Admin::Tab.class_variable_set :@@url_hash, {}
  end

  it "remembers admin tabs and their associated addresses" do
    Cartoonist::Admin::Tab.add :test2, "/testing/2"
    Cartoonist::Admin::Tab.add :test1, "/testing/1"
    Cartoonist::Admin::Tab.add :test3, "/testing/3"
    Cartoonist::Admin::Tab[:test1].should == "/testing/1"
    Cartoonist::Admin::Tab[:test2].should == "/testing/2"
    Cartoonist::Admin::Tab[:test3].should == "/testing/3"
  end

  it "remembers admin tabs in the order they were added" do
    Cartoonist::Admin::Tab.add :test2, "/testing/2"
    Cartoonist::Admin::Tab.add :test1, "/testing/1"
    Cartoonist::Admin::Tab.add :test3, "/testing/3"
    Cartoonist::Admin::Tab.all.should == [:test2, :test1, :test3]
  end

  it "remembers the last url given, and only lists 1 tab" do
    Cartoonist::Admin::Tab.add :test, "/testing/1"
    Cartoonist::Admin::Tab.add :test, "/testing/2"
    Cartoonist::Admin::Tab.add :test, "/testing/3"
    Cartoonist::Admin::Tab[:test].should == "/testing/3"
    Cartoonist::Admin::Tab.all.should == [:test]
  end
end
