$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'Aggregator'
require 'conf/router'

# Run aggregator
app = Thread.new{ Aggregator.new }
app.run

use ActiveRecord::ConnectionAdapters::ConnectionManagement
use ActiveRecord::QueryCache

run Router.map