require 'celluloid'

class PluginWorker
	include Celluloid

	def run(plugin)
		plugin.run
	end
end