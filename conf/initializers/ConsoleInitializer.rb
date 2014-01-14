require 'irb'
require 'irb/completion'

require 'app/utils/Logging'

class ConsoleInitializer 
	include Logging

	def self.start(environment)
		initializer = ConsoleInitializer.new

		initializer.logger.info 'Starting up to console'

		Dir['app/models/*.rb'].each do |f|
			require f
		end

		initializer.logger.info 'Models loaded'

		ENV['IRBRC'] = '.irbrc'
		initializer.logger.info 'Environment variables set'

		puts "Aggregator console:"
		IRB.start
	end
end