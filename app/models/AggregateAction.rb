require 'app/models/Action'

class AggregateAction < Action
	def self.get_time_since_last_execution(name, plugin)
		r = select(:updated_at).where(:name => name, :plugin_id => plugin).last
		unless r.nil?
			return Time.now.to_i - r.updated_at.to_i
		end
		0
	end
end