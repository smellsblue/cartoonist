class Suggestion < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  def formatted_created_at
    created_at.localtime.strftime "%-m/%-d/%Y at %-l:%M %P"
  end

  def shown?
    !hidden
  end

  def hidden?
    hidden
  end

  def toggle!
    self.hidden = !hidden
    save!
  end

  def truncated_content
    truncate content, :length => 256
  end

  def description
    "#{I18n.t "suggestion"}: #{truncated_content}"
  end

  def search_url
    "/admin/suggestions/#{id}"
  end

  class << self
    def search(query)
      reverse_chronological.shown.where "LOWER(name) LIKE :query OR LOWER(email) LIKE :query OR LOWER(ip) LIKE :query OR LOWER(content) LIKE :query", :query => "%#{query.downcase}%"
    end

    def toggle!(params)
      if params[:id].present?
        find(params[:id].to_i).toggle!
      elsif params[:ids].present?
        where(:id => params[:ids].map(&:to_i)).each &:toggle!
      end
    end

    def create_suggestion(ip, params)
      return nil unless params[:content].present?
      create :name => params[:name], :email => params[:email], :ip => ip, :content => params[:content]
    end

    def hidden
      where :hidden => true
    end

    def shown
      where :hidden => false
    end

    def chronological
      order "created_at ASC"
    end

    def reverse_chronological
      order "created_at DESC"
    end
  end
end
