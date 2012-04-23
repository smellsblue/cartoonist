require "spec_helper"

describe AdminController do
  it "redirects to initial setup when an admin page is loaded and there are no users" do
    User.should_receive(:count).and_return(0)
    get :index
    response.should redirect_to("/settings/initial_setup")
  end

  it "doesn't redirect to initial setup if there are users" do
    User.should_receive(:count).and_return(1)
    controller.should_receive(:authenticate_user!).and_return(true)
    get :index
    response.should_not redirect_to("/settings/initial_setup")
  end
end

describe SettingsController do
  it "doesn't allow going to the initial setup if there are users" do
    User.should_receive(:count).and_return(1)
    get :initial_setup
    response.should redirect_to("/admin")
  end

  it "doesn't allow posting to the initial setup if there are users" do
    User.should_receive(:count).and_return(1)
    post :save_initial_setup, :domain => "testing.com", :site_name => "Testing", :admin_email => "user@example.com", :admin_password => "test123", :admin_confirm_password => "test123", :admin_name => "test"
    User.should_not_receive(:create!)
    Setting.should_not_receive(:[]=)
    response.should redirect_to("/admin")
  end

  describe "the initial setup process" do
    before { User.delete_all }

    it "fails if the same password is not given" do
      post :save_initial_setup, :domain => "testing.com", :site_name => "Testing", :admin_email => "user@example.com", :admin_password => "test123", :admin_confirm_password => "test321", :admin_name => "test"
      User.count.should == 0
      response.should redirect_to("/settings/initial_setup")
      flash[:error].should be
    end
  end
end
