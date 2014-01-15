require 'feedzirra'

require 'app/plugins/PluginFrame'

class FeedReader < PluginFrame

	def initialize(plugin_model)
		super plugin_model
	end

	def run
		aggregate_feeds
	end

	private

	def aggregate_feeds
		setting.feeds.each { |feed| aggregate_feed feed}
	end

	def aggregate_feed(feed)
		logger.info "Aggregating from #{feed}."
	end
end