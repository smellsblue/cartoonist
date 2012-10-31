class Admin::SearchController < AdminCartoonistController
  layout "general_admin"

  def index
    @search = Search.query params
  end
end
