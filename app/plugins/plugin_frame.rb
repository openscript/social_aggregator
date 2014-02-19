require 'celluloid'
require 'digest/md5'

require 'app/models/plugin'
require 'app/models/action'
require 'app/models/log'
require 'app/models/message'
require 'app/models/message_category'
require 'app/models/follower'

require 'app/utils/logging'
require 'app/utils/setting'

class PluginFrame
	include Setting
	include Logging
	include Celluloid

	def initialize(plugin_model)
		@plugin = plugin_model

		settings_path @plugin.conf_path
	end

	protected

	# Returns a persisted action by given name
	def get_action(name)
		Action.find_or_create_by!(name: name, plugin: @plugin)
	end

	# Return whether last action occurance was before given time
	def action_ready?(action, timer)
		time_since_last_occurance = action.last_occurance

		status = time_since_last_occurance && time_since_last_occurance <= timer

		unless status
			logger.info "Possible aggregation in #{timer - time_since_last_occurance} seconds."
		end

		status
	end
end