class Domain < ActiveRecord::Base
  attr_accessible :site_id, :site, :name, :description
  belongs_to :site
  before_save :ensure_lower_case_name!

  def enabled?
    enabled
  end

  def disabled?
    !enabled?
  end

  def admin_enabled?
    admin_enabled
  end

  def admin_disabled?
    !admin_enabled?
  end

  def catch_all?
    name.blank?
  end

  private
  def ensure_lower_case_name!
    self.name = self.name.strip.downcase if self.name
  end

  class << self
    def from_name(name)
      name = name.strip.downcase if name
      result = where(:name => name).first
      result = where(:name => nil).first if name && !result
      result
    end
  end
end
