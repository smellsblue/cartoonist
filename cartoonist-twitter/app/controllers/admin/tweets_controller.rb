class Admin::TweetsController < AdminCartoonistController
  def index
    @untweeted = Tweet.untweeted.created_chronological.not_disabled
    @tweeted = Tweet.tweeted.reverse_chronological
  end

  def edit
    @tweet = Tweet.find params[:id].to_i
  end

  def update
    @tweet = Tweet.update_tweet params
    send_tweet_if_requested
    tweet_or_entity_redirect
  end

  def create
    @tweet = Tweet.create_tweet params
    send_tweet_if_requested
    tweet_or_entity_redirect
  end

  private
  def send_tweet_if_requested
    if params[:tweet_now].present?
      @tweet.manual_tweet!
    elsif params[:resend_tweet].present?
      @tweet.resend_tweet!
    end
  end

  def tweet_or_entity_redirect
    if params[:destination] == "entity_edit" && @tweet.entity.entity_edit_url
      redirect_to @tweet.entity.entity_edit_url
    else
      redirect_to "/admin/tweets/#{@tweet.id}/edit"
    end
  end
end
