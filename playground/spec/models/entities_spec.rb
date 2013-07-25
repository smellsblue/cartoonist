require "spec_helper"

describe Entity do
  describe "entity url methods" do
    before do
      Setting.stub(:[]).with(:domain, Site.initial.id).and_return("testdomain.com")
    end

    it "supports the global entity_absolute_url and entity_relative_url methods" do
      BlogPost.entity_relative_url.should == "/blog"
      BlogPost.entity_absolute_url.should == "http://testdomain.com/blog"
      Comic.entity_relative_url.should == "/comic"
      Comic.entity_absolute_url.should == "http://testdomain.com/comic"
      Page.entity_relative_url.should == nil
      Page.entity_absolute_url.should == nil
    end

    it "supports the instance entity_absolute_url and entity_relative_url methods" do
      BlogPost.new(:url_title => "example-blog-post").entity_relative_url.should == "/blog/example-blog-post"
      BlogPost.new(:url_title => "example-blog-post").entity_absolute_url.should == "http://testdomain.com/blog/example-blog-post"
      Comic.new(:number => 42).entity_relative_url.should == "/comic/42"
      Comic.new(:number => 42).entity_absolute_url.should == "http://testdomain.com/comic/42"
      Page.new(:path => "example-path").entity_relative_url.should == "/example-path"
      Page.new(:path => "example-path").entity_absolute_url.should == "http://testdomain.com/example-path"
    end
  end
end
