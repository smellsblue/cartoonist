class Admin::TweetsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @unposted = Tweet.tweeted.chronological
    @posted = Tweet.untweeted.reverse_chronological
  end
end
