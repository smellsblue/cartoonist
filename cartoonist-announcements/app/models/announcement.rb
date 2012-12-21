class Announcement < ActiveRecord::Base
  include Postable
  attr_accessible :posted_at, :expired_at, :title, :content, :location, :enabled
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

  def lock!
    self.locked = true
    save!
  end

  def unlock!
    self.locked = false
    save!
  end

  def expired?
    expired_at && (expired_at < DateTime.now)
  end

  class << self
    def create_announcement(params)
      create :title => params[:title], :content => params[:content], :location => params[:location], :locked => true
    end

    def update_announcement(params)
      announcement = find params[:id].to_i
      raise "Cannot update locked announcement!" if announcement.locked
      announcement.title = params[:title]
      announcement.location = params[:location]
      announcement.content = params[:content]
      announcement.post_from params
      announcement.locked = true
      announcement.save!
      announcement
    end

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
