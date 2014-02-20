$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'conf/initializers/server_initializer'
require 'conf/initializers/database_initializer'
require 'conf/initializers/console_initializer'
require 'app/plugins/plugin_manager'
require 'app/utils/argument_parser'
require 'app/utils/logging'
require 'app/utils/setting'


# Main class
class Aggregator
	include Logging
	include Setting

	# Set aggregator version
	AGGREGATOR_VERSION = '0.0.1' unless const_defined?(:AGGREGATOR_VERSION)
	
	# Set default environment
	@environment = :production

	attr_reader :stop

	# Initialize the whole system
	def initialize(internal_server = false, arguments = [])
		options = ArgumentParser.parse(arguments)

		logger.info "Using #{options.environment} environment"
		Aggregator.environment = options.environment

		Logging::environment Aggregator.environment
		Logging::quiet = true if options.quiet

		logger.info 'Starting up aggregator now'

		DatabaseInitializer.new(options.environment)

		if options.console
			ConsoleInitializer.new(options.environment)
		elsif Aggregator.environment != :test
			Aggregator.plugin_manager = PluginManager.new 

			ServerInitializer.new if internal_server
			
			logger.info "Aggregator is up and running"

			Signal.trap("SIGINT") do
				Thread.current.exit
			end

			start
		end
	end

	# Returns the environment
	def self.environment
		@environment
	end

	# Returns the plugin manager
	def self.plugin_manager
		@plugin_manager
	end

	# Shutdown the system
	def self.shutdown
		@stop = true
	end

	private

	def self.environment=(value)
		@environment = value
	end

	def self.plugin_manager=(value)
		@plugin_manager = value
	end

	def start
		until @stop
			Aggregator.plugin_manager.run

			logger.info "Aggregation done. Next aggregation in #{setting.aggregate_timer} seconds."
			sleep setting.aggregate_timer
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(true, ARGV)
end