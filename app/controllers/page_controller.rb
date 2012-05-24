class PageController < CartoonistController
  def show
    path = params[:id].downcase
    @page = Page.from_path path

    cache_page_as "#{path}.#{cache_type}.html" do
      render
    end
  end
end
