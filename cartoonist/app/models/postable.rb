module Postable
  def posted?
    posted_at && posted_at <= postable_now
  end

  def postable_type
    self.class.postable_type
  end

  def postable_now
    self.class.postable_now
  end

  def formatted_posted_at(default_msg = "not yet posted", options = {})
    return default_msg unless posted_at

    if options[:format]
      posted_at.to_time.localtime.strftime options[:format]
    elsif postable_type == :date
      posted_at.strftime "%-m/%-d/%Y"
    else
      posted_at.localtime.strftime "%-m/%-d/%Y at %-l:%M %P"
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def postable_now
      if postable_type == :date
        Date.today
      else
        Time.now
      end
    end

    def postable_type
      type = columns_hash["posted_at"].type
      raise "Postable's posted_at column type should be :date or :datetime!" unless [:date, :datetime].include?(type)
      type
    end

    def posted
      where "#{quoted_table_name}.posted_at IS NOT NULL AND #{quoted_table_name}.posted_at <= ?", postable_now
    end

    def unposted
      where "#{quoted_table_name}.posted_at IS NULL OR #{quoted_table_name}.posted_at > ?", postable_now
    end

    def chronological
      order "#{quoted_table_name}.posted_at ASC"
    end

    def reverse_chronological
      order "#{quoted_table_name}.posted_at DESC"
    end
  end
end
