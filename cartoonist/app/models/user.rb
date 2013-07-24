class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def zip_title
    name
  end

  def save_auth!(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    save!
  end

  class << self
    def create_user(params)
      create :email => params[:email], :name => params[:name], :password => params[:password], :password_confirmation => params[:confirm_password]
    end

    def delete_user(params)
      User.find(params[:id].to_i).destroy
    end

    def update_user(params)
      user = find params[:id].to_i
      user.email = params[:email]
      user.name = params[:name]

      if params[:password].present? || params[:confirm_password].present?
        user.password = params[:password]
        user.password_confirmation = params[:confirm_password]
      end

      user.save!
      user
    end

    def from_auth(auth)
      where(:provider => auth.provider, :uid => auth.uid).first
    end
  end
end
