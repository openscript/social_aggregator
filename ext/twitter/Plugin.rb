require 'app/plugins/PluginFrame'

class Twitter < PluginFrame

	def initialize(plugin_model)
		super plugin_model

		#Twitter.configure do |c|
		#	c.consumer_key = setting.consumer_key
		#	c.consumer_secret = setting.consumer_secret
		#end
	end
end