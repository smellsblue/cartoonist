require "spec_helper"

describe Tweet do
  let(:site) { create :site }

  it "adds a tweet when saving an entity with tweets posting instantly" do
    Setting.stub(:[]).with(:blog_tweet_style, site.id).and_return(:automatic)
    Setting.stub(:[]).with(:blog_default_tweet, site.id).and_return("New blog post posted!")
    post = BlogPost.create! :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :site => site
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
  end

  it "adds a tweet when saving an entity with tweets posting on a schedule" do
    Setting.stub(:[]).with(:blog_tweet_style, site.id).and_return(:automatic_timed)
    Setting.stub(:[]).with(:blog_default_tweet, site.id).and_return("New blog post posted!")
    Setting.stub(:[]).with(:blog_tweet_time, site.id).and_return("8:00 am")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :site => site, :posted_at => Time.now
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
    tweet.expected_tweet_time.hour.should == 8
    tweet.expected_tweet_time.min.should == 0
  end

  it "adds a tweet when saving an entity with tweets posting manually" do
    Setting.stub(:[]).with(:blog_tweet_style, site.id).and_return(:manual)
    Setting.stub(:[]).with(:blog_default_tweet, site.id).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :site => site
    tweet = Tweet.find_for(post)
    tweet.should be
    tweet.entity_id.should == post.id
    tweet.tweet.should == "New blog post posted!"
    tweet.tweeted_at.should be_nil
  end

  it "doesn't add a tweet when saving an entity with tweets disabled" do
    Setting.stub(:[]).with(:blog_tweet_style, site.id).and_return(:disabled)
    Setting.stub(:[]).with(:blog_default_tweet, site.id).and_return("New blog post posted!")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :site => site
    Tweet.find_for(post).should_not be
  end

  it "allows urls in the default tweet" do
    Setting.stub(:[]).with(:domain, site.id).and_return("example.com")
    Setting.stub(:[]).with(:blog_tweet_style, site.id).and_return(:automatic)
    Setting.stub(:[]).with(:blog_default_tweet, site.id).and_return("New blog post at {{entity_absolute_url}}")
    post = BlogPost.create :title => "Example Post", :url_title => "example-post", :content => "This is the content.", :author => "John Doe", :site => site
    Tweet.find_for(post).tweet.should == "New blog post at http://example.com/blog/example-post"
  end

  it "allows changing before being sent, but not after" do
    tweet = Tweet.create :entity_id => 42, :entity_type => :blog, :tweet => "This is the first draft tweet"
    Tweet.find(tweet.id).tweet.should == "This is the first draft tweet"
    tweet.tweet = "This is the second draft tweet"
    tweet.save!
    Tweet.find(tweet.id).tweet.should == "This is the second draft tweet"
    tweet.tweet = "This is the third draft tweet"
    tweet.tweeted_at = DateTime.now
    tweet.save!
    Tweet.find(tweet.id).tweet.should == "This is the third draft tweet"
    tweet.tweet = "This is the fourth draft tweet"
    tweet.save.should == false
    Tweet.find(tweet.id).tweet.should == "This is the third draft tweet"
  end

  it "doesn't allow changing the entity type or entity id" do
    tweet = Tweet.create :entity_id => 42, :entity_type => :blog, :tweet => "The tweet message"
    tweet.entity_id = 41
    tweet.save.should == false
    tweet = Tweet.find tweet.id
    tweet.entity_type = :comic
    tweet.save.should == false
  end
end
