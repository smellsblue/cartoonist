require "spec_helper"

describe "Admin plugin interface" do
  before do
    Cartoonist::Admin::Tab.class_variable_set :@@all, {}
    Cartoonist::Admin::Tab.class_variable_set :@@cached_order, []
  end

  it "remembers admin tabs and their associated addresses" do
    Cartoonist::Admin::Tab.add :test2, :url => "/testing/2"
    Cartoonist::Admin::Tab.add :test1, :url => "/testing/1"
    Cartoonist::Admin::Tab.add :test3, :url => "/testing/3"
    Cartoonist::Admin::Tab[:test1].should == "/testing/1"
    Cartoonist::Admin::Tab[:test2].should == "/testing/2"
    Cartoonist::Admin::Tab[:test3].should == "/testing/3"
  end

  it "orders tabs in sorted order if no order is specified" do
    Cartoonist::Admin::Tab.add :test2, :url => "/testing/2"
    Cartoonist::Admin::Tab.add :test1, :url => "/testing/1"
    Cartoonist::Admin::Tab.add :test3, :url => "/testing/3"
    Cartoonist::Admin::Tab.all.should == [:test1, :test2, :test3]
  end

  it "orders tabs in as specified, if order is given" do
    Cartoonist::Admin::Tab.add :test2, :url => "/testing/2", :order => 0
    Cartoonist::Admin::Tab.add :test1, :url => "/testing/1", :order => 1
    Cartoonist::Admin::Tab.add :test3, :url => "/testing/3", :order => 2
    Cartoonist::Admin::Tab.all.should == [:test2, :test1, :test3]
  end

  it "orders tabs in as specified, if order is given, followed by missing order in alphabetical order" do
    Cartoonist::Admin::Tab.add :abc2, :url => "/abc/2"
    Cartoonist::Admin::Tab.add :abc1, :url => "/abc/1"
    Cartoonist::Admin::Tab.add :abc3, :url => "/abc/3"
    Cartoonist::Admin::Tab.add :test2, :url => "/testing/2", :order => 0
    Cartoonist::Admin::Tab.add :test1, :url => "/testing/1", :order => 1
    Cartoonist::Admin::Tab.add :test3, :url => "/testing/3", :order => 2
    Cartoonist::Admin::Tab.all.should == [:test2, :test1, :test3, :abc1, :abc2, :abc3]
  end

  it "remembers the last url given, and only lists 1 tab" do
    Cartoonist::Admin::Tab.add :test, :url => "/testing/1"
    Cartoonist::Admin::Tab.add :test, :url => "/testing/2"
    Cartoonist::Admin::Tab.add :test, :url => "/testing/3"
    Cartoonist::Admin::Tab[:test].should == "/testing/3"
    Cartoonist::Admin::Tab.all.should == [:test]
  end
end
