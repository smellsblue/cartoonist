class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :entity_id, :null => false
      t.string :entity_type, :null => false
      t.string :tweet, :null => false, :length => 140
      t.datetime :tweeted_at
    end

    add_index :tweets, :tweeted_at
    add_index :tweets, [:entity_id, :entity_type], :unique => true
  end
end
