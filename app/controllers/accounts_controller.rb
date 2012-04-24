class AccountsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
    @users = User.order(:name).all
  end

  def create
    user = User.create_user params
    redirect_to "/accounts"
  end

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

  def destroy
    raise "Cannot destroy yourself!" if current_user.id == params[:id].to_i
    User.delete_user params
    redirect_to "/accounts"
  end
end
