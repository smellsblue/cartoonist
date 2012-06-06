class MoveComicTitleSetting < ActiveRecord::Migration
  def up
    return puts "Skipping MoveComicTitleSetting up migration" if ENV["SkipMoveComicTitleSetting"] == "true"
    raise "Uh oh... default_comic_title already exists... run with environment variable SkipMoveComicTitleSetting=true to skip this migration." if Setting.where(:label => "default_comic_title").count > 0

    Setting.where(:label => "default_title").each do |setting|
      setting.label = "default_comic_title"
      setting.save!
    end
  end

  def down
    return puts "Skipping MoveComicTitleSetting down migration" if ENV["SkipMoveComicTitleSetting"] == "true"
    raise "Uh oh... default_title already exists... run with environment variable SkipMoveComicTitleSetting=true to skip this migration." if Setting.where(:label => "default_title").count > 0

    Setting.where(:label => "default_comic_title").each do |setting|
      setting.label = "default_title"
      setting.save!
    end
  end
end
