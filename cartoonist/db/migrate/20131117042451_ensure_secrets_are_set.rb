class EnsureSecretsAreSet < ActiveRecord::Migration
  def up
    # We don't need to do any of this if they haven't gone through
    # initial setup yet.
    return if User.count == 0

    if Setting[:secret_token] == Setting::Meta[:secret_token].default
      puts "Setting secret_token"
      Setting[:secret_token] = SecureRandom.hex 30
    end

    if Setting[:secret_key_base] == Setting::Meta[:secret_key_base].default
      puts "Setting secret_key_base"
      Setting[:secret_key_base] = SecureRandom.hex 64
    end

    if Setting[:devise_pepper] == Setting::Meta[:devise_pepper].default
      puts "Setting devise_pepper"
      Setting[:devise_pepper] = SecureRandom.hex 64
    end

    if Setting[:devise_secret_key] == Setting::Meta[:devise_secret_key].default
      puts "Setting devise_secret_key"
      Setting[:devise_secret_key] = SecureRandom.hex 64
    end
  end

  def down
  end
end
