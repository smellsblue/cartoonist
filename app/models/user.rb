class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

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
  end
end
