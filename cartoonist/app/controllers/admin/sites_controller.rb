class Admin::SitesController < AdminCartoonistController
  def index
    @sites = Site.order(:name).all
  end

  def new
  end

  def create
    Site.create_site params
    redirect_to "/admin/sites"
  end

  def show
    @site = Site.find params[:id].to_i
  end

  def edit
    @site = Site.find params[:id].to_i
  end

  def update
    site = Site.update_site params
    redirect_to "/admin/sites/#{site.id}"
  end
end
