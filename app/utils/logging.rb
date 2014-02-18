require 'logger'

module Logging
	@@level = Logger::INFO
	@@output = STDOUT
	@loggers = {}

	def self.quiet=(toggle)
		if toggle
			@@level = Logger::UNKNOWN
		end
	end

	def self.environment(environment)
		case environment
		when :development
			@@level = Logger::DEBUG
			@@output = STDOUT
		when :production
			@@level = Logger::WARN
			@@output = 'tmp/log/aggregator.log'
		end
	end

	def logger
		@logger ||= Logging.logger_for(self.class.name)
	end

	def logger_for(name)
		Logging.logger_for(name)
	end

	class << self
		def logger_for(classname)
			@loggers[classname] ||= configure_logger_for(classname)
		end

		def configure_logger_for(classname)
			logger = Logger.new(@@output)

			logger.progname = classname
			logger.level = @@level

			logger
		end
	end
end