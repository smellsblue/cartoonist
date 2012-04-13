require "spec_helper"

describe StaticCache do
  def file_directory_stub(files)
    files = full_path_files files
    File.stub :directory? do |f|
      files.include? f
    end
  end

  def dir_glob_stub(files)
    files = full_path_files files
    Dir.stub :glob do |g, options|
      g.should == File.join(Rails.root, "public/cache/static/**/*")
      options.should == File::FNM_DOTMATCH
      files
    end
  end

  def full_path_files(files)
    files.map { |x| File.join(Rails.root, "public/cache/static", x) }
  end

  describe "all method" do
    it "returns an empty array when no static cache files exist" do
      dir_glob_stub []
      file_directory_stub []
      StaticCache.all.should == []
    end

    it "returns an array of 1 file if 1 file is cached" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz"]
      file_directory_stub []
      result = StaticCache.all
      result.map(&:name).should == ["favicon.ico"]
    end

    it "returns an array of several files if several files are cached" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub []
      result = StaticCache.all
      result.map(&:name).should == ["1.png", "2.png", "favicon.ico"]
    end

    it "doesn't include directories" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir", "subdir/1.png", "subdir/1.png.gz"]
      file_directory_stub ["subdir"]
      result = StaticCache.all
      result.map(&:name).should == ["favicon.ico", "subdir/1.png"]
    end
  end

  describe "find" do
    it "raises an exception when there are no static cache files" do
      dir_glob_stub []
      file_directory_stub []
      lambda { StaticCache.find("4.png") }.should raise_error
    end

    it "raises an exception when there is no matching static file" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub []
      lambda { StaticCache.find("4.png") }.should raise_error
    end

    it "doesn't find matching file if the only match is a directory" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "test", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub ["test"]
      lambda { StaticCache.find("test") }.should raise_error
    end

    it "doesn't find matching file if the only match is in a subdirectory" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir", "subdir/1.png", "subdir/1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub ["subdir"]
      lambda { StaticCache.find("1.png") }.should raise_error
    end

    it "doesn't find matching file if the only match is in the wrong directory" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir", "subdir/1.png", "subdir/1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub ["subdir"]
      lambda { StaticCache.find("subdir/2.png") }.should raise_error
      lambda { StaticCache.find("subdir_other/1.png") }.should raise_error
    end

    it "finds the specified file when there is one" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub []
      result = StaticCache.find "2.png"
      result.name.should == "2.png"
    end

    it "finds the specified file when there is one and it is in a subdirectory" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir/1.png", "subdir/1.png.gz", "subdir/2.png", "subdir/2.png.gz"]
      file_directory_stub []
      result = StaticCache.find "subdir/2.png"
      result.name.should == "subdir/2.png"
    end
  end

  describe "expire! method" do
    it "deletes the specified static file, and it's gz file" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub []
      File.should_receive(:delete).with(*full_path_files(["1.png"]))
      File.should_receive(:delete).with(*full_path_files(["1.png.gz"]))
      StaticCache.find("1.png").expire!
    end

    it "deletes the specified static file from a subdirectory, and it's gz file" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir", "subdir/1.png", "subdir/1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub ["subdir"]
      File.should_receive(:delete).with(*full_path_files(["subdir/1.png"]))
      File.should_receive(:delete).with(*full_path_files(["subdir/1.png.gz"]))
      StaticCache.find("subdir/1.png").expire!
    end
  end

  describe "expire_all! method" do
    it "doesn't delete anything if there are no files" do
      dir_glob_stub []
      file_directory_stub []
      File.should_not_receive(:delete)
      StaticCache.expire_all!
    end

    it "doesn't delete anything if there are only directories" do
      dir_glob_stub ["subdir"]
      file_directory_stub ["subdir"]
      File.should_not_receive(:delete)
      StaticCache.expire_all!
    end

    it "deletes any static files" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]
      file_directory_stub []
      File.should_receive(:delete).with(*full_path_files(["favicon.ico", "favicon.ico.gz", "1.png", "1.png.gz", "2.png", "2.png.gz"]))
      StaticCache.expire_all!
    end

    it "deletes any static files, but not directories" do
      dir_glob_stub ["favicon.ico", "favicon.ico.gz", "subdir", "subdir/1.png", "subdir/1.png.gz", "subdir/2.png", "subdir/2.png.gz"]
      file_directory_stub ["subdir"]
      File.should_receive(:delete).with(*full_path_files(["favicon.ico", "favicon.ico.gz", "subdir/1.png", "subdir/1.png.gz", "subdir/2.png", "subdir/2.png.gz"]))
      StaticCache.expire_all!
    end
  end
end
