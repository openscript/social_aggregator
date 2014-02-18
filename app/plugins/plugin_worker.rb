require 'celluloid'

class PluginWorker
	include Celluloid

	def run(plugin)
		# Connection per plugin
		ActiveRecord::Base.connection_pool.with_connection do
			plugin.run
		end
	end
end