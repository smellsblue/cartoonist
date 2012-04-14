module Tweetable
  def tweet!
    return if tweeted?
    return unless Time.now >= expected_tweet_time

    if Rails.env.production?
      Twitter.update tweet
    end

    self.tweeted_at = Time.now
    save!
  end

  def tweeted?
    tweeted_at.present?
  end
end
