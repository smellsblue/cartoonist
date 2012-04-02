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

ActiveRecord::Schema.define(:version => 20120401014029) do

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                         :null => false
    t.string   "url_title",                     :null => false
    t.string   "author",                        :null => false
    t.datetime "posted_at"
    t.text     "content",                       :null => false
    t.string   "tweet",                         :null => false
    t.datetime "tweeted_at"
    t.boolean  "locked",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "blog_posts", ["posted_at"], :name => "index_blog_posts_on_posted_at"
  add_index "blog_posts", ["title"], :name => "index_blog_posts_on_title", :unique => true
  add_index "blog_posts", ["url_title"], :name => "index_blog_posts_on_url_title", :unique => true

  create_table "comics", :force => true do |t|
    t.integer  "number",                               :null => false
    t.date     "posted_at",                            :null => false
    t.string   "title",                                :null => false
    t.text     "description",                          :null => false
    t.text     "scene_description",                    :null => false
    t.text     "dialogue",                             :null => false
    t.text     "title_text",                           :null => false
    t.integer  "database_file_id",                     :null => false
    t.string   "tweet",                                :null => false
    t.datetime "tweeted_at"
    t.boolean  "locked",            :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "comics", ["number"], :name => "index_comics_on_number", :unique => true
  add_index "comics", ["posted_at"], :name => "index_comics_on_posted_at"

  create_table "database_files", :force => true do |t|
    t.string   "filename"
    t.binary   "content",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
  end

  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true
  add_index "pages", ["title"], :name => "index_pages_on_title", :unique => true

  create_table "settings", :force => true do |t|
    t.string   "label",                         :null => false
    t.text     "value"
    t.boolean  "locked",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "settings", ["label"], :name => "index_settings_on_label", :unique => true

end
