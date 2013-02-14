# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130214061140) do

  create_table "announcements", :force => true do |t|
    t.datetime "posted_at"
    t.datetime "expired_at"
    t.string   "title"
    t.text     "content",                       :null => false
    t.string   "location"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "locked",     :default => false, :null => false
    t.integer  "site_id",    :default => 1,     :null => false
  end

  add_index "announcements", ["expired_at"], :name => "index_announcements_on_expired_at"
  add_index "announcements", ["posted_at", "expired_at"], :name => "index_announcements_on_posted_at_and_expired_at"

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                         :null => false
    t.string   "url_title",                     :null => false
    t.string   "author",                        :null => false
    t.datetime "posted_at"
    t.text     "content",                       :null => false
    t.boolean  "locked",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "site_id",    :default => 1,     :null => false
  end

  add_index "blog_posts", ["posted_at"], :name => "index_blog_posts_on_posted_at"
  add_index "blog_posts", ["title", "site_id"], :name => "index_blog_posts_on_title_and_site_id", :unique => true
  add_index "blog_posts", ["url_title", "site_id"], :name => "index_blog_posts_on_url_title_and_site_id", :unique => true

  create_table "comics", :force => true do |t|
    t.integer  "number",                               :null => false
    t.date     "posted_at",                            :null => false
    t.string   "title",                                :null => false
    t.text     "description",                          :null => false
    t.text     "scene_description",                    :null => false
    t.text     "dialogue",                             :null => false
    t.text     "title_text",                           :null => false
    t.integer  "database_file_id",                     :null => false
    t.boolean  "locked",            :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "site_id",           :default => 1,     :null => false
  end

  add_index "comics", ["number", "site_id"], :name => "index_comics_on_number_and_site_id", :unique => true
  add_index "comics", ["posted_at"], :name => "index_comics_on_posted_at"

  create_table "database_files", :force => true do |t|
    t.string   "filename"
    t.binary   "content",                   :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "extension"
    t.integer  "site_id",    :default => 1, :null => false
  end

  create_table "entity_tags", :force => true do |t|
    t.integer  "entity_id",                  :null => false
    t.string   "entity_type",                :null => false
    t.integer  "tag_id",                     :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "site_id",     :default => 1, :null => false
  end

  add_index "entity_tags", ["entity_id", "entity_type", "tag_id", "site_id"], :name => "index_entity_tags_on_entity_id__entity_type__tag_id__site_id", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "title",                         :null => false
    t.string   "path",                          :null => false
    t.date     "posted_at"
    t.text     "content",                       :null => false
    t.boolean  "locked",     :default => false, :null => false
    t.boolean  "comments",   :default => false, :null => false
    t.boolean  "in_sitemap", :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "site_id",    :default => 1,     :null => false
  end

  add_index "pages", ["path", "site_id"], :name => "index_pages_on_path_and_site_id", :unique => true
  add_index "pages", ["title", "site_id"], :name => "index_pages_on_title_and_site_id", :unique => true

  create_table "settings", :force => true do |t|
    t.string   "label",                         :null => false
    t.text     "value"
    t.boolean  "locked",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "site_id",    :default => 1,     :null => false
  end

  add_index "settings", ["label", "site_id"], :name => "index_settings_on_label_and_site_id", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "name",                          :null => false
    t.text     "description"
    t.boolean  "enabled",     :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "sites", ["name"], :name => "index_sites_on_name", :unique => true

  create_table "suggestions", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "ip"
    t.text     "content",                       :null => false
    t.text     "options"
    t.boolean  "hidden",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "site_id",    :default => 1,     :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "label",                     :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "site_id",    :default => 1, :null => false
  end

  add_index "tags", ["label", "site_id"], :name => "index_tags_on_label_and_site_id", :unique => true

  create_table "tweets", :force => true do |t|
    t.integer  "entity_id",                  :null => false
    t.string   "entity_type",                :null => false
    t.string   "tweet",                      :null => false
    t.datetime "tweeted_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "site_id",     :default => 1, :null => false
  end

  add_index "tweets", ["entity_id", "entity_type", "site_id"], :name => "index_tweets_on_entity_id_and_entity_type_and_site_id", :unique => true
  add_index "tweets", ["tweeted_at"], :name => "index_tweets_on_tweeted_at"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
