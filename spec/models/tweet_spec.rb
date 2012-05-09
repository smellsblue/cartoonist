require "spec_helper"

describe Tweet do
  it "adds a tweet when saving an entity with tweets posting instantly" do
    Setting.stub(:[]).with(:blog_tweet_style).and_return(:automatic)
    Setting.stub(:[]).with(:blog_default_tweet).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :tweet => "REMOVE THIS EVENTUALLY"
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
  end

  it "adds a tweet when saving an entity with tweets posting on a schedule" do
    Setting.stub(:[]).with(:blog_tweet_style).and_return(:automatic_timed)
    Setting.stub(:[]).with(:blog_default_tweet).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :tweet => "REMOVE THIS EVENTUALLY"
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
  end

  it "adds a tweet when saving an entity with tweets posting manually" do
    Setting.stub(:[]).with(:blog_tweet_style).and_return(:manual)
    Setting.stub(:[]).with(:blog_default_tweet).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :tweet => "REMOVE THIS EVENTUALLY"
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
  end

  it "doesn't add a tweet when saving an entity with tweets disabled" do
    Setting.stub(:[]).with(:blog_tweet_style).and_return(:disabled)
    Setting.stub(:[]).with(:blog_default_tweet).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :tweet => "REMOVE THIS EVENTUALLY"
    Tweet.find_for(post).should_not be
  end

  it "allows urls in the default tweet" do
    Setting.stub(:[]).with(:domain).and_return("example.com")
    Setting.stub(:[]).with(:blog_tweet_style).and_return(:automatic)
    Setting.stub(:[]).with(:blog_default_tweet).and_return("New blog post at {{entity_absolute_url}}")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :tweet => "REMOVE THIS EVENTUALLY"
    Tweet.find_for(post).tweet.should == "New blog post at http://example.com/blog/example-post"
  end

  it "allows changing the tweet manually via updates"
  it "creates a tweet if it doesn't exist when manually tweeting immediately"
  it "doesn't update a tweet that has already been sent out"
end
