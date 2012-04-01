require "spec_helper"

describe Setting do
  before do
    Setting::Meta.class_variable_set :@@configs, {}
    Setting::Meta.class_variable_set :@@by_tab_section_and_label, {}
    Setting::Tab.class_variable_set :@@all, []
    Setting::Tab.class_variable_set :@@by_label, {}
    Setting::Section.class_variable_set :@@all, []
    Setting::Section.class_variable_set :@@by_tab_and_label, {}
    Setting::Tab.define :general, :order => 0
    Setting::Section.define :general, :order => 0, :tab => :general
  end

  it "fails on missing meta" do
    lambda { Setting[:missing_config] }.should raise_error
    lambda { Setting::Meta[:missing_config] }.should raise_error
  end

  it "supports string types" do
    Setting.define :test_config, :type => :string
    Setting::Meta[:test_config].type.should == :string
    Setting[:test_config] = "This is a test"
    Setting[:test_config].should == "This is a test"
  end

  it "supports symbol types" do
    Setting.define :test_config, :type => :symbol
    Setting::Meta[:test_config].type.should == :symbol
    Setting[:test_config] = :test_value
    Setting[:test_config].should == :test_value
    Setting[:test_config] = "This is a test"
    Setting[:test_config].should == "This is a test".to_sym
  end

  it "supports int types" do
    Setting.define :test_config, :type => :int
    Setting::Meta[:test_config].type.should == :int
    Setting[:test_config] = 5
    Setting[:test_config].should == 5
  end

  it "supports boolean types" do
    Setting.define :test_config, :type => :boolean
    Setting::Meta[:test_config].type.should == :boolean
    Setting[:test_config] = 1
    Setting[:test_config].should == true
    Setting[:test_config] = nil
    Setting[:test_config].should == false
    Setting[:test_config] = false
    Setting[:test_config].should == false
  end

  it "supports float types" do
    Setting.define :test_config, :type => :float
    Setting::Meta[:test_config].type.should == :float
    Setting[:test_config] = 4.2
    Setting[:test_config].should == 4.2
  end

  it "supports array types" do
    Setting.define :test_config, :type => :array
    Setting::Meta[:test_config].type.should == :array
    Setting[:test_config] = ["testing", 1, 2, 3]
    Setting[:test_config].should == ["testing", 1, 2, 3]
  end

  it "supports hash types" do
    Setting.define :test_config, :type => :hash
    Setting::Meta[:test_config].type.should == :hash
    Setting[:test_config] = { :a => "123", "b" => 321 }
    Setting[:test_config].should == { :a => "123", "b" => 321 }
  end

  it "defaults to string types" do
    Setting.define :test_config
    Setting::Meta[:test_config].type.should == :string
    Setting[:test_config] = "This is a test"
    Setting[:test_config].should == "This is a test"
  end

  it "has default values for all types" do
    Setting.define :test_config_string, :type => :string
    Setting.define :test_config_symbol, :type => :symbol
    Setting.define :test_config_boolean, :type => :boolean
    Setting.define :test_config_int, :type => :int
    Setting.define :test_config_float, :type => :float
    Setting.define :test_config_array, :type => :array
    Setting.define :test_config_hash, :type => :hash
    Setting[:test_config_string].should == ""
    Setting[:test_config_symbol].should == :""
    Setting[:test_config_boolean].should == false
    Setting[:test_config_int].should == 0
    Setting[:test_config_float].should == 0.0
    Setting[:test_config_array].should == []
    Setting[:test_config_hash].should == {}
  end

  it "disallows multiple config values of the same label" do
    Setting.define :test_config
    lambda { Setting.define :test_config }.should raise_error
  end

  it "supports explicit default values" do
    Setting.define :test_config, :default => "This is the default"
    Setting[:test_config].should == "This is the default"
  end

  # Specs for the sections (used for display)
  it "defaults to putting settings in general tab and general section" do
    Setting.define :test_config
    Setting::Meta[:test_config].tab.should == :general
    Setting::Meta[:test_config].section.should == :general
  end

  it "sorts tabs properly" do
    Setting::Tab.define :cherry
    Setting::Tab.define :banana
    Setting::Tab.define :apple, :order => 2
    Setting.tabs.should == [:general, :banana, :cherry, :apple]
  end

  it "sorts sections properly" do
    Setting::Section.define :cherry
    Setting::Section.define :banana
    Setting::Section.define :apple, :order => 2
    Setting::Tab[:general].sections.should == [:general, :banana, :cherry, :apple]
  end

  it "defines the details for the general tab/section" do
    Setting.tabs.should == [:general]
    Setting::Tab[:general].order.should == 0
    Setting::Tab[:general].sections.should == [:general]
    Setting::Tab[:general][:general].order.should == 0
  end

  it "sorts settings properly" do
    Setting.define :cherry
    Setting.define :banana
    Setting.define :apple, :order => 1
    Setting::Tab[:general][:general].configs.should == [:banana, :cherry, :apple]
  end
end
