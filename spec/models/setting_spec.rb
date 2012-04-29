require "spec_helper"

describe Setting do
  before do
    Setting::Meta.class_variable_set :@@settings, {}
    Setting::Meta.class_variable_set :@@by_tab_section_and_label, {}
    Setting::Tab.class_variable_set :@@all, []
    Setting::Tab.class_variable_set :@@by_label, {}
    Setting::Section.class_variable_set :@@all, []
    Setting::Section.class_variable_set :@@by_tab_and_label, {}
    Setting::Tab.define :general, :order => 0
    Setting::Section.define :general, :order => 0, :tab => :general
  end

  it "fails on missing meta" do
    lambda { Setting[:missing_setting] }.should raise_error
    lambda { Setting::Meta[:missing_setting] }.should raise_error
  end

  it "supports string types" do
    Setting.define :test_setting, :type => :string
    Setting::Meta[:test_setting].type.should == :string
    Setting[:test_setting] = "This is a test"
    Setting[:test_setting].should == "This is a test"
  end

  it "supports symbol types" do
    Setting.define :test_setting, :type => :symbol
    Setting::Meta[:test_setting].type.should == :symbol
    Setting[:test_setting] = :test_value
    Setting[:test_setting].should == :test_value
    Setting[:test_setting] = "This is a test"
    Setting[:test_setting].should == "This is a test".to_sym
  end

  it "supports int types" do
    Setting.define :test_setting, :type => :int
    Setting::Meta[:test_setting].type.should == :int
    Setting[:test_setting] = 5
    Setting[:test_setting].should == 5
  end

  it "supports boolean types" do
    Setting.define :test_setting, :type => :boolean
    Setting::Meta[:test_setting].type.should == :boolean
    Setting[:test_setting] = 1
    Setting[:test_setting].should == true
    Setting[:test_setting] = nil
    Setting[:test_setting].should == false
    Setting[:test_setting] = false
    Setting[:test_setting].should == false
  end

  it "supports float types" do
    Setting.define :test_setting, :type => :float
    Setting::Meta[:test_setting].type.should == :float
    Setting[:test_setting] = 4.2
    Setting[:test_setting].should == 4.2
  end

  it "supports array types" do
    Setting.define :test_setting, :type => :array
    Setting::Meta[:test_setting].type.should == :array
    Setting[:test_setting] = ["testing", 1, 2, 3]
    Setting[:test_setting].should == ["testing", 1, 2, 3]
  end

  it "supports hash types" do
    Setting.define :test_setting, :type => :hash
    Setting::Meta[:test_setting].type.should == :hash
    Setting[:test_setting] = { :a => "123", "b" => 321 }
    Setting[:test_setting].should == { :a => "123", "b" => 321 }
  end

  it "defaults to string types" do
    Setting.define :test_setting
    Setting::Meta[:test_setting].type.should == :string
    Setting[:test_setting] = "This is a test"
    Setting[:test_setting].should == "This is a test"
  end

  it "has default values for all types" do
    Setting.define :test_setting_string, :type => :string
    Setting.define :test_setting_symbol, :type => :symbol
    Setting.define :test_setting_boolean, :type => :boolean
    Setting.define :test_setting_int, :type => :int
    Setting.define :test_setting_float, :type => :float
    Setting.define :test_setting_array, :type => :array
    Setting.define :test_setting_hash, :type => :hash
    Setting[:test_setting_string].should == ""
    Setting[:test_setting_symbol].should == :""
    Setting[:test_setting_boolean].should == false
    Setting[:test_setting_int].should == 0
    Setting[:test_setting_float].should == 0.0
    Setting[:test_setting_array].should == []
    Setting[:test_setting_hash].should == {}
  end

  it "disallows multiple setting values of the same label" do
    Setting.define :test_setting
    lambda { Setting.define :test_setting }.should raise_error
  end

  it "supports explicit default values" do
    Setting.define :test_setting, :default => "This is the default"
    Setting[:test_setting].should == "This is the default"
  end

  it "supports onchange lambdas" do
    call_count = 0
    Setting.define :test_setting, :onchange => lambda { call_count += 1 }
    Setting[:test_setting] = "abc 123"
    call_count.should == 1
    Setting[:test_setting] = "xyz 123"
    call_count.should == 2
    Setting[:test_setting] = "xyz 123"
    call_count.should == 2
  end

  # Specs for the sections (used for display)
  it "defaults to putting settings in general tab and general section" do
    Setting.define :test_setting
    Setting::Meta[:test_setting].tab.should == :general
    Setting::Meta[:test_setting].section.should == :general
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
    Setting::Tab[:general][:general].settings.should == [:banana, :cherry, :apple]
  end

  it "allows tabs and sections to be defined using blocks" do
    Setting::Tab.define :apple do
      Setting.define :test1
    end

    Setting::Tab.define :banana do
      Setting::Section.define :artichoke do
        Setting.define :test2
      end

      Setting::Section.define :brussel_sprouts do
        Setting.define :test3
      end

      Setting.define :test4
    end

    Setting.define :test5

    Setting::Tab[:banana].sections.should == [:general, :artichoke, :brussel_sprouts]

    Setting::Meta[:test1].tab.should == :apple
    Setting::Meta[:test1].section.should == :general

    Setting::Meta[:test2].tab.should == :banana
    Setting::Meta[:test2].section.should == :artichoke

    Setting::Meta[:test3].tab.should == :banana
    Setting::Meta[:test3].section.should == :brussel_sprouts

    Setting::Meta[:test4].tab.should == :banana
    Setting::Meta[:test4].section.should == :general

    Setting::Meta[:test5].tab.should == :general
    Setting::Meta[:test5].section.should == :general
  end

  it "doesn't break when defining tab content in multiple engines" do
    Setting::Tab.define :fruits do
      Setting::Section.define :banana, :order => 1 do
        Setting.define :banana_allowed, :type => :boolean
      end

      Setting::Section.define :apple, :order => 3 do
        Setting.define :apple_allowed, :type => :boolean
      end
    end

    Setting::Section.define :orange, :order => 2, :tab => :fruits do
      Setting.define :orange_allowed, :type => :boolean
    end

    Setting::Tab[:fruits][:banana].settings.should == [:banana_allowed]
    Setting::Tab[:fruits][:apple].settings.should == [:apple_allowed]
    Setting::Tab[:fruits][:orange].settings.should == [:orange_allowed]
  end
end
