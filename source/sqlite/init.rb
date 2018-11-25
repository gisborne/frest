require 'sqlite'

f = SQLite3::Database.new 'frest.sqlite'

f.execute_batch File.read 'initialize.sql'

module FREST
  module SQLite
    @db = f
  end
end
