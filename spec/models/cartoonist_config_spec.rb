require "spec_helper"

describe CartoonistConfig do
  before { CartoonistConfig::Meta.class_variable_set :@@configs, {} }

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
end
