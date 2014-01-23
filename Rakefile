require 'rake'
require 'yaml'
require 'active_record'
require 'logger'
require 'bundler'

namespace :aggregator do
	desc 'Migrate migrations to database'
	task :migrate do
		ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Base.establish_connection(ENV['env'] ? ENV['env'] : 'defaults')
		ActiveRecord::Migrator.migrate('db/migrations', ENV['ver'] ? ENV['ver'].to_i : nil)	
	end

	desc 'Create database'
	task :create do
		ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Base.establish_connection(ENV['env'] ? ENV['env'] : 'defaults')
		ActiveRecord::Migrator.up('db/migrations', ENV['ver'] ? ENV['ver'].to_i : nil)	
	end

	desc 'Drop database'
	task :drop do
		ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Base.establish_connection(ENV['env'] ? ENV['env'] : 'defaults')
		ActiveRecord::Migrator.down('db/migrations', ENV['ver'] ? ENV['ver'].to_i : nil)	
	end

	desc 'Install the environment for the aggregator'
	task :install do
		Rake::Task['aggregator:create'].invoke
	end
end