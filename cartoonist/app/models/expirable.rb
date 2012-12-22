module Expirable
  def expired?
    expired_at && (expired_at < DateTime.now)
  end

  def expire_from(params)
    if params[:expire_now].present? && !expired?
      self.expired_at = Time.now
    elsif params[:expire_in_hour].present? && !expired?
      self.expired_at = 1.hour.from_now
    elsif params[:expire_day_after].present? && !expired?
      self.expired_at = posted_at + 1.day
    elsif params[:expire_3_days_after].present? && !expired?
      self.expired_at = posted_at + 3.days
    elsif params[:expired].present? && params[:expired_at_date].present?
      time = "#{params[:expired_at_date]} #{params[:expired_at_hour]}:#{params[:expired_at_minute]} #{params[:expired_at_meridiem]}"
      time = DateTime.parse time
      time = Time.local time.year, time.month, time.day, time.hour, time.min
      self.expired_at = time
    elsif params[:expired].present?
      self.expired_at = 1.hour.from_now
    else
      self.expired_at = nil
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def expired
      where "#{quoted_table_name}.expired_at IS NOT NULL AND #{quoted_table_name}.expired_at < ?", DateTime.now
    end

    def unexpired
      where "#{quoted_table_name}.expired_at IS NULL OR #{quoted_table_name}.expired_at >= ?", DateTime.now
    end
  end
end
