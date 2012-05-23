require "spec_helper"

describe Markdown do
  describe "without link_to_absolute" do
    it "leaves a link alone" do
      Markdown.render('[My link](/my_relative_link)').strip.should == '<p><a href="/my_relative_link">My link</a></p>'
    end

    it "leaves a link with a title alone" do
      Markdown.render('[My link](/my_relative_link "Link title")').strip.should == '<p><a href="/my_relative_link" title="Link title">My link</a></p>'
    end

    it "handles sanitization properly" do
      Markdown.render('[My link](/my_relative_"sanitized"_link "Link title")').strip.should == '<p><a href="/my_relative_%22sanitized%22_link" title="Link title">My link</a></p>'
    end
  end

  describe "with link_to_absolute" do
    before { Setting.stub(:[]).with(:domain).and_return("mydomain.com") }

    it "leaves an absolute link alone" do
      Markdown.render('[My link](http://example.com/my_absolute_link)', :link_to_absolute => true).strip.should == '<p><a href="http://example.com/my_absolute_link">My link</a></p>'
    end

    it "leaves an absolute link with a title alone" do
      Markdown.render('[My link](http://example.com/my_absolute_link "Link title")', :link_to_absolute => true).strip.should == '<p><a href="http://example.com/my_absolute_link" title="Link title">My link</a></p>'
    end

    it "converts a relative link to an absolute link" do
      Markdown.render('[My link](/my_relative_link)', :link_to_absolute => true).strip.should == '<p><a href="http://mydomain.com/my_relative_link">My link</a></p>'
    end

    it "converts a relative link with a title to an absolute link" do
      Markdown.render('[My link](/my_relative_link "Link title")', :link_to_absolute => true).strip.should == '<p><a href="http://mydomain.com/my_relative_link" title="Link title">My link</a></p>'
    end

    it "handles sanitization properly" do
      pending "Sanitization doesn't work yet, the special href sanitizing of Redcarpet is done in C, and I'm not sure yet how to access it (if it is even accessible)"
      Markdown.render('[My link](/my_relative_"sanitized"_link "Link title")', :link_to_absolute => true).strip.should == '<p><a href="http://mydomain.com/my_relative_%22sanitized%22_link" title="Link title">My link</a></p>'
    end
  end
end
