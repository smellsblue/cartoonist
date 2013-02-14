class Site < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :domains

  def enabled?
    enabled
  end

  def disabled?
    !enabled?
  end

  class << self
    def initial
      order("id ASC").first
    end

    def from_name(name)
      where(:name => name).first
    end
  end
end
