require "spec_helper"

describe AdminController do
  it "redirects to initial setup when an admin page is loaded and there are no users" do
    User.should_receive(:count).and_return(0)
    get :show
    response.should redirect_to("/admin/settings/initial_setup")
  end

  it "doesn't redirect to initial setup if there are users" do
    User.should_receive(:count).and_return(1)
    controller.should_receive(:authenticate_user!).and_return(true)
    get :show
    response.should_not redirect_to("/admin/settings/initial_setup")
  end
end

describe Admin::SettingsController do
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
      response.should redirect_to("/admin/settings/initial_setup")
      flash[:error].should be
    end

    it "succeeds and sets all the settings if all the info is provided" do
      SecureRandom.should_receive(:hex).and_return("first")
      SecureRandom.should_receive(:hex).and_return("second")
      SecureRandom.should_receive(:hex).and_return("third")
      Setting.should_receive(:[]=).with(:copyright_starting_year, Date.today.strftime("%Y").to_i)
      Setting.should_receive(:[]=).with(:domain, "testing.com")
      Setting.should_receive(:[]=).with(:site_name, "Testing")
      Setting.should_receive(:[]=).with(:secret_token, "first")
      Setting.should_receive(:[]=).with(:secret_key_base, "second")
      Setting.should_receive(:[]=).with(:devise_pepper, "third")
      post :save_initial_setup, :domain => "testing.com", :site_name => "Testing", :admin_email => "user@example.com", :admin_password => "test123", :admin_confirm_password => "test123", :admin_name => "test"
      User.count.should == 1
      user = User.first
      user.email.should == "user@example.com"
      user.name.should == "test"
      response.should redirect_to("/admin")
    end
  end
end
