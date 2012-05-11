class Admin::TweetsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @untweeted = Tweet.untweeted.created_chronological
    @tweeted = Tweet.tweeted.reverse_chronological
  end
end
