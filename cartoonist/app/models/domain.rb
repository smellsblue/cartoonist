class Domain < ActiveRecord::Base
  attr_accessible :site_id, :site, :name, :description
  belongs_to :site
  before_save :ensure_lower_case_name!
  before_save :ensure_blank_name_saves_as_nil!

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

  def ensure_blank_name_saves_as_nil!
    self.name = nil if self.name.blank?
  end

  class << self
    def from_name(name)
      name = name.strip.downcase if name
      result = where(:name => name).first
      result = where(:name => nil).first if name && !result
      result
    end

    def update_for(site, params)
      params[:domains].each do |id, domain_params|
        next if id == "new"
        domain = Domain.find id.to_i
        raise "Wrong domain!" if domain.site_id != site.id
        domain.name = domain_params[:name]
        domain.description = domain_params[:description]
        domain.enabled = domain_params[:enabled] == "true"
        domain.admin_enabled = domain_params[:admin_enabled] == "true"
        domain.save!
      end

      domain_params = params[:domains][:new]

      if domain_params.present? && (domain_params[:name].present? || domain_params[:description].present?)
        create! do |domain|
          domain.site = site
          domain.name = domain_params[:name]
          domain.description = domain_params[:description]
          domain.enabled = domain_params[:enabled] == "true"
          domain.admin_enabled = domain_params[:admin_enabled] == "true"
        end
      end
    end
  end
end
