class AnnouncementsAdminController < ApplicationController
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def index
  end
end
