module Lockable
  def locked?
    locked
  end

  def toggle_lock_target
    if locked?
      "unlock"
    else
      "lock"
    end
  end

  def lock_disabled_html
    if locked?
      'disabled="disabled"'.html_safe
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

  def ensure_unlocked!
    raise "Cannot update this when it is locked!" if locked?
  end
end
