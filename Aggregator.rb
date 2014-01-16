$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'yaml'

require 'conf/initializers/DatabaseInitializer'
require 'conf/initializers/ConsoleInitializer'
require 'conf/initializers/ServerInitializer'
require 'app/plugins/PluginManager'
require 'app/utils/ArgumentParser'
require 'app/utils/Logging'
require 'app/utils/Setting'


# Main class
class Aggregator
	include Logging
	include Setting

	VERSION = '0.0.1'
	
	@@environment = :production
	@@stop = false

	def initialize(arguments)
		options = ArgumentParser.parse(arguments)

		Logging::environment options.environment
		# Set up logger
		if options.quiet
			Logging::quiet = true
		end

		logger.info 'Starting up aggregator now'

		# Set environment to setting
		logger.info "Using #{options.environment} environment"
		@@environment = options.environment

		# Connect database with orm
		DatabaseInitializer.new(options.environment)

		unless options.environment == :test || options.console
			# Set up plugin manager
			@@plugin_manager = PluginManager.new 

			# Spawn new server
			ServerInitializer.new
			
			start
		end

		if options.console
			ConsoleInitializer.new(options.environment)
		end
	end

	def self.environment
		@@environment
	end

	def self.version
		VERSION
	end

	def self.shutdown
		@@stop = true
	end

	def self.plugin_manager
		@@plugin_manager
	end

	def start
		logger.info "Aggregator is up and running"

		while true
			@@plugin_manager.run
			if @@stop
				logger.info "Stopping aggregation now, due request to stop."
				break
			end
			logger.debug "Next aggregation in #{setting.aggregate_timer} seconds."

			sleep setting.aggregate_timer
		end

		logger.info "Stopping aggregator - Good bye!"
	end
end

# Initialize aggregator
if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(ARGV)
end