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

    def create_site(params)
      site = nil

      transaction do
        site = create! do |s|
          s.name = params[:name]
          s.description = params[:description]
          s.enabled = params[:enabled] == "true"
        end

        Domain.update_for site, params
      end

      site
    end

    def update_site(params)
      site = find params[:id].to_i

      transaction do
        site.name = params[:name]
        site.description = params[:description]
        site.enabled = params[:enabled] == "true"
        site.save!
        Domain.update_for site, params
      end

      site
    end
  end
end
