require 'celluloid/autostart'

require 'app/models/Plugin'
require 'app/models/Action'
require 'app/models/Message'
require 'app/models/MessageCategory'
require 'app/models/Follower'
require 'app/models/AggregateAction'

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

		logger.info "The plugin #{@plugin.name} has been initialized."
	end

	def run
		logger.warn "The plugin #{@plugin.name} is not implemented!"
		terminate
	end

	def unload
		logger.warn "The plugin #{@plugin.name} is terminating!"
	end

	protected

	def get_action(name)
		Action.find_or_initialize_by(:name => name, :plugin => @plugin)
	end
end