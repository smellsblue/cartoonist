class CreateSecretKeyBase < ActiveRecord::Migration
  def change
    Setting[:secret_key_base] = SecureRandom.hex 64
  end
end
