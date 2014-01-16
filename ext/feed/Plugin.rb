require 'feedzirra'
require 'digest/md5'

require 'app/plugins/PluginFrame'

# Simple feed reader plugin
class FeedReader < PluginFrame

	def initialize(plugin_model)
		super plugin_model
	end

	def run
		aggregate_feeds
	end

	private

	def aggregate_feeds
		setting.feeds.each{ |feed| aggregate_feed feed }
	end

	def aggregate_feed(feed_url)
		logger.info "Aggregating from #{feed_url}."

		feed = Feedzirra::Feed.fetch_and_parse(feed_url)

		message_category = MessageCategory.find_or_initialize_by(:fingerprint => Digest::MD5.hexdigest(feed.url))

		if message_category.action.nil?
			message_category.action = get_action('aggregate_feed')
		end

		if message_category.name.nil? || message_category.name.empty? || message_category.name != feed.title
			message_category.name = feed.title
		end

		unless message_category.persisted?
			message_category.save!
		end

		feed.entries.each do |entry|
			message = Message.find_or_initialize_by(:fingerprint => Digest::MD5.hexdigest(entry.url))
			message.message_category = message_category

			if message.published_at.nil? || message.published_at < message.published
				message.published_at = entry.published
				message.summary = entry.summary
				message.content = entry.content
				message.title = entry.title
			end

			message.save!
			logger.info "Persisting new/updating message (#{message.title})."
		end
	end
end