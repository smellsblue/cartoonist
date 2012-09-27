class AdminCartoonistController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  private
  def ensure_ssl!
    return unless Rails.env.production?
    redirect_to "https://#{request.host_with_port}#{request.fullpath}" unless request.ssl?
  end

  def check_admin!
    if initial_setup_required?
      redirect_to "/admin/settings/initial_setup"
    else
      authenticate_user!
    end
  end

  def initial_setup_required?
    User.count == 0
  end

  def after_sign_out_path_for(resource_or_scope)
    "/admin"
  end

  def after_sign_in_path_for(resource_or_scope)
    "/admin"
  end

  def preview!
    @for_preview = true
  end
end
