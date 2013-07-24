# TODO: Make this searchable
class Announcement < ActiveRecord::Base
  include Postable
  include Expirable
  include Lockable
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

  def as_hash
    {
      :id => id,
      :title => title,
      :content => Markdown.render(content),
      :location => location
    }
  end

  class << self
    def create_announcement(params)
      create :title => params[:title], :content => params[:content], :location => params[:location], :locked => true
    end

    def update_announcement(params)
      announcement = find params[:id].to_i
      announcement.ensure_unlocked!
      announcement.title = params[:title]
      announcement.location = params[:location]
      announcement.content = params[:content]
      announcement.post_from params
      announcement.expire_from params
      announcement.locked = true
      announcement.save!
      announcement
    end

    def actives_as_hash
      active.creation_order.map &:as_hash
    end

    def creation_order
      order :id
    end

    def active
      posted.unexpired
    end

    def future
      unposted
    end
  end
end
