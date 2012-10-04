class Admin::SuggestionsController < AdminCartoonistController
  def index
    @suggestions = Suggestion.shown.reverse_chronological
  end

  def toggle
    Suggestion.toggle! params

    if params[:id].present?
      redirect_to "/admin/suggestions/#{params[:id]}"
    else
      redirect_to "/admin/suggestions"
    end
  end

  def show
    @suggestion = Suggestion.find params[:id].to_i
  end
end
