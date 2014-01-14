require 'rake'
require 'yaml'
require 'active_record'
require 'logger'

desc 'Migrate migrations to database'
task :migrate do
	ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
	ActiveRecord::Base.logger = Logger.new(STDOUT)
	ActiveRecord::Base.establish_connection(ENV['env'] ? ENV['env'] : 'defaults')
	ActiveRecord::Migrator.migrate('db/migrations', ENV['ver'] ? ENV['ver'].to_i : nil)	
end

desc 'Install the environment for the aggregator'
task :install do

end