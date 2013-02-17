class Admin::DomainsController < AdminCartoonistController
  def destroy
    domain = Domain.find params[:id].to_i
    site_id = domain.site_id
    domain.destroy
    redirect_to "/admin/sites/#{site_id}"
  end
end
