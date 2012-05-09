require "spec_helper"

describe SimpleTemplate do
  it "returns empty string if nil is provided" do
    SimpleTemplate[nil].should == ""
    SimpleTemplate[nil, nil].should == ""
  end

  it "returns the string provided if there are no variables embedded" do
    SimpleTemplate[""].should == ""
    SimpleTemplate["abc"].should == "abc"
    SimpleTemplate["", nil].should == ""
    SimpleTemplate["abc", nil].should == "abc"
    SimpleTemplate["", :abc => 123].should == ""
    SimpleTemplate["abc", :abc => 123].should == "abc"
  end

  it "returns ignores invalid variables" do
    SimpleTemplate["{{}}", :abc => 123].should == ""
    SimpleTemplate["{{xyz}}", :abc => 123].should == ""
    SimpleTemplate["{{}}  abc", :abc => 123].should == "  abc"
    SimpleTemplate["{{xyz}}  abc", :abc => 123].should == "  abc"
    SimpleTemplate["{{}}"].should == ""
    SimpleTemplate["{{xyz}}"].should == ""
    SimpleTemplate["{{}}", nil].should == ""
    SimpleTemplate["{{xyz}}", nil].should == ""
  end

  it "replaces single variables" do
    SimpleTemplate["{{abc}}", :abc => 123].should == "123"
    SimpleTemplate["{{abc}} abc", :abc => 123].should == "123 abc"
  end

  it "replaces single variables with multiplace instances" do
    SimpleTemplate["{{abc}}{{abc}}", :abc => 123].should == "123123"
    SimpleTemplate["{{abc}} abc {{abc}}", :abc => 123].should == "123 abc 123"
  end

  it "replaces multiple variables" do
    SimpleTemplate["{{abc}}{{xyz}}", :abc => 123, :xyz => "hello"].should == "123hello"
    SimpleTemplate["{{abc}} abc {{xyz}}{{abc}}", :abc => 123, :xyz => "hello"].should == "123 abc hello123"
  end

  it "allows lambdas in place of variables" do
    SimpleTemplate["{{abc}}", :abc => lambda { 123 }].should == "123"
  end

  it "doesn't invoke lambdas that are not embedded" do
    invoked = 0
    SimpleTemplate["{{xyz}}", :abc => lambda { invoked += 1; 123 }, :xyz => "abc"].should == "abc"
    invoked.should == 0
  end

  it "invokes lambdas multiple times if they are called multiple times" do
    invoked = 0
    SimpleTemplate["{{abc}} {{abc}}", :abc => lambda { invoked += 1; (123 + invoked) }].should == "124 125"
    invoked.should == 2
  end

  it "supports referencing methods via special self" do
    example = Object.new
    def example.abc; "123"; end
    def example.xyz; "456"; end
    SimpleTemplate["{{abc}} {{xyz}}", :self => example].should == "123 456"
  end

  it "allows overriding self methods" do
    example = Object.new
    def example.abc; "123"; end
    def example.xyz; "456"; end
    SimpleTemplate["{{abc}} {{xyz}}", :self => example, :abc => 789].should == "789 456"
  end
end
