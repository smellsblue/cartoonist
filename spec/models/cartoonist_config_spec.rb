require "spec_helper"

describe CartoonistConfig do
  before do
    CartoonistConfig::Meta.class_variable_set :@@configs, {}
    CartoonistConfig::Meta.class_variable_set :@@by_tab_section_and_label, {}
    CartoonistConfig::Tab.class_variable_set :@@all, []
    CartoonistConfig::Tab.class_variable_set :@@by_label, {}
    CartoonistConfig::Section.class_variable_set :@@all, []
    CartoonistConfig::Section.class_variable_set :@@by_tab_and_label, {}
    CartoonistConfig::Tab.define :general, :order => 0
    CartoonistConfig::Section.define :general, :order => 0, :tab => :general
  end

  it "fails on missing meta" do
    lambda { CartoonistConfig[:missing_config] }.should raise_error
    lambda { CartoonistConfig::Meta[:missing_config] }.should raise_error
  end

  it "supports string types" do
    CartoonistConfig.define :test_config, :type => :string
    CartoonistConfig::Meta[:test_config].type.should == :string
    CartoonistConfig[:test_config] = "This is a test"
    CartoonistConfig[:test_config].should == "This is a test"
  end

  it "supports symbol types" do
    CartoonistConfig.define :test_config, :type => :symbol
    CartoonistConfig::Meta[:test_config].type.should == :symbol
    CartoonistConfig[:test_config] = :test_value
    CartoonistConfig[:test_config].should == :test_value
    CartoonistConfig[:test_config] = "This is a test"
    CartoonistConfig[:test_config].should == "This is a test".to_sym
  end

  it "supports int types" do
    CartoonistConfig.define :test_config, :type => :int
    CartoonistConfig::Meta[:test_config].type.should == :int
    CartoonistConfig[:test_config] = 5
    CartoonistConfig[:test_config].should == 5
  end

  it "supports boolean types" do
    CartoonistConfig.define :test_config, :type => :boolean
    CartoonistConfig::Meta[:test_config].type.should == :boolean
    CartoonistConfig[:test_config] = 1
    CartoonistConfig[:test_config].should == true
    CartoonistConfig[:test_config] = nil
    CartoonistConfig[:test_config].should == false
    CartoonistConfig[:test_config] = false
    CartoonistConfig[:test_config].should == false
  end

  it "supports float types" do
    CartoonistConfig.define :test_config, :type => :float
    CartoonistConfig::Meta[:test_config].type.should == :float
    CartoonistConfig[:test_config] = 4.2
    CartoonistConfig[:test_config].should == 4.2
  end

  it "supports array types" do
    CartoonistConfig.define :test_config, :type => :array
    CartoonistConfig::Meta[:test_config].type.should == :array
    CartoonistConfig[:test_config] = ["testing", 1, 2, 3]
    CartoonistConfig[:test_config].should == ["testing", 1, 2, 3]
  end

  it "supports hash types" do
    CartoonistConfig.define :test_config, :type => :hash
    CartoonistConfig::Meta[:test_config].type.should == :hash
    CartoonistConfig[:test_config] = { :a => "123", "b" => 321 }
    CartoonistConfig[:test_config].should == { :a => "123", "b" => 321 }
  end

  it "defaults to string types" do
    CartoonistConfig.define :test_config
    CartoonistConfig::Meta[:test_config].type.should == :string
    CartoonistConfig[:test_config] = "This is a test"
    CartoonistConfig[:test_config].should == "This is a test"
  end

  it "has default values for all types" do
    CartoonistConfig.define :test_config_string, :type => :string
    CartoonistConfig.define :test_config_symbol, :type => :symbol
    CartoonistConfig.define :test_config_boolean, :type => :boolean
    CartoonistConfig.define :test_config_int, :type => :int
    CartoonistConfig.define :test_config_float, :type => :float
    CartoonistConfig.define :test_config_array, :type => :array
    CartoonistConfig.define :test_config_hash, :type => :hash
    CartoonistConfig[:test_config_string].should == ""
    CartoonistConfig[:test_config_symbol].should == :""
    CartoonistConfig[:test_config_boolean].should == false
    CartoonistConfig[:test_config_int].should == 0
    CartoonistConfig[:test_config_float].should == 0.0
    CartoonistConfig[:test_config_array].should == []
    CartoonistConfig[:test_config_hash].should == {}
  end

  it "disallows multiple config values of the same label" do
    CartoonistConfig.define :test_config
    lambda { CartoonistConfig.define :test_config }.should raise_error
  end

  it "supports explicit default values" do
    CartoonistConfig.define :test_config, :default => "This is the default"
    CartoonistConfig[:test_config].should == "This is the default"
  end

  # Specs for the sections (used for display)
  it "defaults to putting settings in general tab and general section" do
    CartoonistConfig.define :test_config
    CartoonistConfig::Meta[:test_config].tab.should == :general
    CartoonistConfig::Meta[:test_config].section.should == :general
  end

  it "sorts tabs properly" do
    CartoonistConfig::Tab.define :cherry
    CartoonistConfig::Tab.define :banana
    CartoonistConfig::Tab.define :apple, :order => 2
    CartoonistConfig.tabs.should == [:general, :banana, :cherry, :apple]
  end

  it "sorts sections properly" do
    CartoonistConfig::Section.define :cherry
    CartoonistConfig::Section.define :banana
    CartoonistConfig::Section.define :apple, :order => 2
    CartoonistConfig::Tab[:general].sections.should == [:general, :banana, :cherry, :apple]
  end

  it "defines the details for the general tab/section" do
    CartoonistConfig.tabs.should == [:general]
    CartoonistConfig::Tab[:general].order.should == 0
    CartoonistConfig::Tab[:general].sections.should == [:general]
    CartoonistConfig::Tab[:general][:general].order.should == 0
  end

  it "sorts settings properly" do
    CartoonistConfig.define :cherry
    CartoonistConfig.define :banana
    CartoonistConfig.define :apple, :order => 1
    CartoonistConfig::Tab[:general][:general].configs.should == [:banana, :cherry, :apple]
  end
end
