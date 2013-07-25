class Admin::AccountsController < AdminCartoonistController
  def index
    @users = User.order(:name).to_a
  end

  def new
  end

  def create
    User.create_user params
    redirect_to "/admin/accounts"
  end

  def show
    @user = User.find params[:id].to_i
  end

  def edit
    @user = User.find params[:id].to_i
  end

  def update
    user = User.update_user params
    redirect_to "/admin/accounts/#{user.id}"
  end

  def destroy
    raise "Cannot destroy yourself!" if current_user.id == params[:id].to_i
    User.delete_user params
    redirect_to "/admin/accounts"
  end
end
