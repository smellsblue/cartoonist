class Announcement < ActiveRecord::Base
  validate :posted_at_must_be_before_expired_at, :posted_at_must_exist_if_expired_at_exists

  def posted_at_must_be_before_expired_at
    if posted_at && expired_at && posted_at > expired_at
      errors.add :posted_at, "must be before expiration"
    end
  end

  def posted_at_must_exist_if_expired_at_exists
    if expired_at && !posted_at
      errors.add :posted_at, "must exist if expiration exists"
    end
  end

  class << self
    def disabled
      where :enabled => false
    end

    def enabled
      where :enabled => true
    end

    def active
      where "posted_at < ? AND (expired_at IS NULL OR expired_at > ?)", DateTime.now, DateTime.now
    end

    def expired
      where "expired_at < ?", DateTime.now
    end

    def future
      where "posted_at IS NULL OR posted_at > ?", DateTime.now
    end
  end
end
