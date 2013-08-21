require 'celluloid/autostart'

require 'app/models/Plugin'
require 'app/models/Message'
require 'app/models/Follower'
require 'app/models/AggregateAction'

require 'app/controllers/MessagesController'
require 'app/utils/Logging'
require 'app/utils/Setting'

class PluginFrame
	include Celluloid
	include Setting
	include Logging

	finalizer :unload

	def initialize(plugin_model)
		@plugin = plugin_model

		settings_path @plugin.conf_path
	end

	def run
		logger.warn "The plugin #{@plugin.name} is not implemented!"
		terminate
	end

	def unload
		logger.warn "The plugin #{@plugin.name} is terminating!"
	end
end