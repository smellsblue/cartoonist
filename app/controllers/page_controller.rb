class PageController < CartoonistController
  def show
    path = params[:id].downcase
    @page = Page.from_path path
    render
    cache_page_as "#{path}.#{cache_type}.html"
  end
end
