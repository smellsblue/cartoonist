class Admin::PageController < AdminCartoonistController
  before_filter :preview!, :only => [:preview]

  def preview
    @page = Page.preview_from_path params[:id]
    render "page/show", :layout => "page"
  end

  def preview_content
    render :text => Markdown.render(params[:content]), :layout => false
  end

  def index
    @unposted = Page.unposted.ordered
    @posted = Page.posted.ordered
  end

  def create
    page = Page.create_page params
    redirect_to "/admin/page/#{page.id}/edit"
  end

  def edit
    @page = Page.find params[:id].to_i
  rescue ActiveRecord::RecordNotFound
    redirect_to "/admin/page/new"
  end

  def update
    page = Page.update_page params
    redirect_to "/admin/page/#{page.id}/edit"
  end

  def lock
    page = Page.find params[:id].to_i
    page.lock!
    redirect_to "/admin/page/#{page.id}/edit"
  end

  def unlock
    page = Page.find params[:id].to_i
    page.unlock!
    redirect_to "/admin/page/#{page.id}/edit"
  end
end
