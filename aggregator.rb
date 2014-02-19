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

	# The version constant
	AGGREGATOR_VERSION = '0.0.1' unless const_defined?(:AGGREGATOR_VERSION)
	
	# Stores the environment
	@@environment = :production

	attr_reader :stop

	# Initialize the whole system
	def initialize(internal_server = false, arguments = [])
		options = ArgumentParser.parse(arguments)

		# Set environment to setting
		logger.info "Using #{options.environment} environment"
		@@environment = options.environment

		Logging::environment @@environment
		Logging::quiet = true if options.quiet

		logger.info 'Starting up aggregator now'

		# Connect database with orm
		DatabaseInitializer.new(options.environment)

		if options.console
			ConsoleInitializer.new(options.environment)
		elsif @@environment != :test
			@@plugin_manager = PluginManager.new 

			ServerInitializer.new if internal_server
			
			logger.info "Aggregator is up and running"

			Signal.trap("SIGINT") do
				Thread.current.exit
			end

			start
		end
	end

	# Returns the current environment
	def self.environment
		@@environment
	end

	# Returns the version number
	def self.version
		AGGREGATOR_VERSION
	end

	# Returns the plugin manager
	def self.plugin_manager
		@@plugin_manager
	end

	# Shutdown the system
	def self.shutdown
		@stop = true
	end

	private

	# Starts the aggregation
	def start
		@@plugin_manager.run

		if @stop
			logger.info "Stopping aggregation now, due request to stop."
			return
		end

		logger.debug "Aggregation done. Next aggregation in #{setting.aggregate_timer} seconds."

		sleep setting.aggregate_timer
		start
	end
end

if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(true, ARGV)
end