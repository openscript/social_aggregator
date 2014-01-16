require 'irb'
require 'irb/completion'

require 'app/utils/Logging'

class ConsoleInitializer 
	include Logging

	def initialize(environment)
		logger.info 'Starting up console'

		Dir['app/models/*.rb'].each do |f|
			require f
		end
		logger.info 'Models loaded'

		ENV['IRBRC'] = '.irbrc'
		logger.info 'Environment variables set'

		puts "Aggregator console:"
		IRB.start
	end
end