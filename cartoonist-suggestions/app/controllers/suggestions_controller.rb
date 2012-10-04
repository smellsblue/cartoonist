class SuggestionsController < CartoonistController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    Suggestion.create_suggestion request.remote_ip, params
    redirect_to "/"
  end

  def new
    cache_page_as "suggestions/new.#{cache_type}.html" do
      render
    end
  end
end
