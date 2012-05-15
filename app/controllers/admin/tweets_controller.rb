class Admin::TweetsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @untweeted = Tweet.untweeted.created_chronological.not_disabled
    @tweeted = Tweet.tweeted.reverse_chronological
  end

  def edit
    @tweet = Tweet.find params[:id].to_i
  end

  def update
    tweet = Tweet.update_tweet params

    if params[:destination] == "entity_edit" && tweet.entity.entity_edit_url
      redirect_to tweet.entity.entity_edit_url
    else
      redirect_to "/admin/tweets/#{tweet.id}/edit"
    end
  end
end
