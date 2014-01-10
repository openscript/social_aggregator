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
	@stop = false

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

		# Set up orm
		DatabaseInitializer::start(options.environment)

		unless options.environment == :test
			# Set up plugin manager
			@@plugin_manager = PluginManager.new unless options.console

			# Set up server
			ServerInitializer::start

			if options.console
				ConsoleInitializer::start(options.environment)
			else
				start
			end
		end
	end

	def self.environment
		@@environment
	end

	def self.version
		VERSION
	end

	def self.stop
		@stop = true
	end

	def self.plugin_manager
		@@plugin_manager
	end

	def start
		logger.info "Aggregator is up and running"

		while true
			@@plugin_manager.run
			break if @stop
			logger.debug "Next aggregation in #{setting.aggregate_timer} seconds."
			sleep setting.aggregate_timer
		end

		logger.info "Stopping aggregator"
	end
end

# Initialize aggregator
if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(ARGV)
end