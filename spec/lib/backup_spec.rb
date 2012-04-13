require "spec_helper"

describe "Backup plugin interface" do
  before do
    Cartoonist::Backup.class_variable_set :@@all, {}
  end

  it "allows backing up arbitrary data" do
    Cartoonist::Backup.for :testing do
      [1, 1, 2, 3, 5, 8]
    end

    Backup.all.should == { :testing => [1, 1, 2, 3, 5, 8] }
  end

  it "invokes each backup block per backup call" do
    invoked = 0

    Cartoonist::Backup.for :testing do
      invoked += 1
    end

    Backup.all.should == { :testing => 1 }
    Backup.all.should == { :testing => 2 }
  end

   it "support backing up several keys" do
    Cartoonist::Backup.for :testing do
      [1, 1, 2, 3, 5, 8]
    end

    Cartoonist::Backup.for :other do
      "testing"
    end

    Backup.all.should == { :testing => [1, 1, 2, 3, 5, 8], :other => "testing" }
  end
end
