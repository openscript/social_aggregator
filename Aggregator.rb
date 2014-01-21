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

	# Defines the version
	VERSION = '0.0.1' unless const_defined?(:VERSION)
	
	@@environment = :production
	@@stop = false

	# Initialize the whole system
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

	# Returns the current environment
	def self.environment
		@@environment
	end

	# Returns the version number
	def self.version
		VERSION
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
		logger.info "Aggregator is up and running"

		while true
			@@plugin_manager.run

			if @@stop
				logger.info "Stopping aggregation now, due request to stop."
				break
			end
			logger.debug "Aggregation done. Next aggregation in #{setting.aggregate_timer} seconds."

			begin
				sleep setting.aggregate_timer
			rescue StandardError => e
				logger.warn "Sleep was interrupted."
			end
		end

		logger.info "Stopping aggregator - Good bye!"
	end
end

# Initialize aggregator
if __FILE__ == $PROGRAM_NAME
	app = Aggregator.new(ARGV)
end