class DatabaseFile < ActiveRecord::Base
  attr_accessible :filename, :content
end
