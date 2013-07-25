class CreateSecretKeyBase < ActiveRecord::Migration
  def change
    Site.initial.settings[:secret_key_base] = SecureRandom.hex 64
  end
end
