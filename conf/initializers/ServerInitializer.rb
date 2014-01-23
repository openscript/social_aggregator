require 'Aggregator'
require 'app/utils/Logging'
require 'app/utils/Setting'
require 'conf/router'

require 'sinatra/base'
require 'sinatra/reloader' if Aggregator::environment == :development
require 'webrick'
require 'rack'

class ServerInitializer 
	include Logging
	include Setting

	def initialize
		server = Rack::Builder.new do
			use ActiveRecord::ConnectionAdapters::ConnectionManagement
			use ActiveRecord::QueryCache

			run Router.map
		end

		options = {
			:BindAddress	=> setting.server_bind,
			:Port			=> setting.server_port,
			:AccessLog		=> [[WEBrick::Log.new('tmp/log/access.log'), WEBrick::AccessLog::COMBINED_LOG_FORMAT]],
			:Logger 		=> WEBrick::Log.new('tmp/log/server.log')
		}

		@server = Thread.new do
			Thread.current[:stdout] = nil
			Rack::Handler::WEBrick.run server, options
		end

		logger.info "Server started on #{options[:BindAddress]}:#{options[:Port]}"
	end
end