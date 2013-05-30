require 'celluloid/autostart'

require 'app/controllers/MessagesController'
require 'app/utils/Logging'
require 'app/utils/Setting'

class PluginFrame
	include Celluloid
	include Setting
	include Logging

	def initialize(plugin_model)
		@model = plugin_model

		settings_path @model.conf_path
	end

	
end