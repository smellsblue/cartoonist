class Suggestion < ActiveRecord::Base
  class << self
    def create_suggestion(ip, params)
      return nil unless params[:content].present?
      create :name => params[:name], :email => params[:email], :ip => ip, :content => params[:content]
    end
  end
end
