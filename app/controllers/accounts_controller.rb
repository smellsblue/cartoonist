class AccountsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def show
    @user = User.find params[:id].to_i
  end

  def edit
    @user = User.find params[:id].to_i
  end

  def update
    user = User.update_user params
    redirect_to "/accounts/#{user.id}"
  end
end
