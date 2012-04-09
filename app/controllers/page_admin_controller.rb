class PageAdminController < ApplicationController
  before_filter :preview!, :only => [:preview]
  before_filter :ensure_ssl!
  before_filter :check_admin!

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
    path = params[:path].downcase
    raise "Invalid path" unless path =~ /^[-_a-z0-9]+$/
    page = Page.create :title => params[:title], :path => path, :content => params[:content], :locked => true
    redirect_to "/page_admin/#{page.id}/edit"
  end

  def edit
    @page = Page.find params[:id].to_i
  rescue ActiveRecord::RecordNotFound
    redirect_to "/page_admin/new"
  end

  def update
    path = params[:path].downcase
    raise "Invalid path" unless path =~ /^[-_a-z0-9]+$/
    page = Page.find params[:id].to_i
    raise "Cannot update locked page!" if page.locked
    page.title = params[:title]
    page.path = path
    page.content = params[:content]
    page.locked = true
    page.comments = !!params[:comments]
    page.in_sitemap = !!params[:in_sitemap]

    if params[:posted]
      page.posted_at = Date.today
    else
      page.posted_at = nil
    end

    page.save!
    redirect_to "/page_admin/#{page.id}/edit"
  end

  def lock
    page = Page.find params[:id].to_i
    page.locked = true
    page.save!
    redirect_to "/page_admin/#{page.id}/edit"
  end

  def unlock
    page = Page.find params[:id].to_i
    page.locked = false
    page.save!
    redirect_to "/page_admin/#{page.id}/edit"
  end
end
