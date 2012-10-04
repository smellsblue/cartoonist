class Suggestion < ActiveRecord::Base
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

  class << self
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
