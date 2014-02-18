require 'active_record'

require 'app/utils/logging'

class DatabaseInitializer 
	include Logging

	def initialize(environment)
		logger.info 'Connecting to database'

		if environment == :development
			ActiveRecord::Base.logger = logger_for('ActiveRecord')
		else
			ActiveRecord::Base.logger = Logger.new('tmp/log/db.log')
		end

		ActiveRecord::Base.configurations = YAML.load_file('conf/database.yml')
		ActiveRecord::Base.establish_connection(environment)
		logger.info 'Database connection established'
	end
end