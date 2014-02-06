$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'conf/initializers/DatabaseInitializer'
require 'conf/initializers/ConsoleInitializer'
require 'app/plugins/PluginManager'
require 'app/utils/ArgumentParser'
require 'app/utils/Logging'
require 'app/utils/Setting'


# Main class
class Aggregator
	include Logging
	include Setting

	# The version constant
	AGGREGATOR_VERSION = '0.0.1' unless const_defined?(:AGGREGATOR_VERSION)
	
	# Stores the environment
	@@environment = :production

	# Stores the run state
	@@stop = false

	# Initialize the whole system
	def initialize(internal_server = false, arguments = [])
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

			if internal_server
				require 'conf/initializers/ServerInitializer'
				
				# Spawn new server
				ServerInitializer.new
			end
			
			logger.info "Aggregator is up and running"

			Signal.trap("SIGINT") do
				Thread.current.exit
			end

			start
		end

		if options.console
			ConsoleInitializer.new(options.environment)
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
		@@stop = true
	end

	private

	# Starts the aggregation
	def start
		@@plugin_manager.run

		if @@stop
			logger.info "Stopping aggregation now, due request to stop."
			return
		end

		logger.debug "Aggregation done. Next aggregation in #{setting.aggregate_timer} seconds."

		sleep setting.aggregate_timer
		start
	end
end

# Initialize aggregator
if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(true, ARGV)
end