require 'celluloid'
require 'digest/md5'

require 'app/models/Plugin'
require 'app/models/Action'
require 'app/models/Log'
require 'app/models/Message'
require 'app/models/MessageCategory'
require 'app/models/Follower'
require 'app/models/AggregateAction'

require 'app/utils/Logging'
require 'app/utils/Setting'

class PluginFrame
	include Setting
	include Logging
	include Celluloid

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

	# Returns a persisted action by given name
	def get_action(name)
		Action.find_or_create_by!(name: name, plugin: @plugin)
	end

	# Return whether last action occurance was before given time
	def action_ready?(action, timer)
		time_until_aggregation = action.last_occurance

		unless time_until_aggregation.nil? || time_until_aggregation < timer
			logger.info "Possible aggregation in #{setting.follower_timer - time_until_aggregation} seconds."
			return false
		end
		return true
	end
end