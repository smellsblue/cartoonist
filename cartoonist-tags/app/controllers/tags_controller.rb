class TagsController < CartoonistController
  def show
    @tag = Tag.find params[:id].to_i

    cache_page_as "tags/#{@tag.id}.#{cache_type}.tmp.html" do
      render
    end
  end
end
