class Domain < ActiveRecord::Base
  attr_accessible :site_id, :site, :name, :description
  belongs_to :site
  before_save :ensure_lower_case_name!

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
