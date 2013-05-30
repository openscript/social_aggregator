require 'active_record'

require 'app/utils/Logging'

class DatabaseInitializer 
	include Logging

	def self.start(environment)
		initializer = DatabaseInitializer.new

		initializer.logger.info 'Connecting to database'

		if environment == :development
			ActiveRecord::Base.logger = initializer.logger_for('ActiveRecord')
		else
			ActiveRecord::Base.logger = Logger.new('tmp/log/db.log')
		end

		ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
		ActiveRecord::Base.establish_connection(environment)
		initializer.logger.info 'Database connection established'
	end
end