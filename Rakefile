require 'rake'
require 'yaml'
require 'active_record'
require 'logger'

desc 'Migrate migrations'
task :migrate do
	ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
	ActiveRecord::Base.logger = Logger.new(STDOUT)
	ActiveRecord::Base.establish_connection(ENV['env'])
	ActiveRecord::Migrator.migrate('db/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)	
end