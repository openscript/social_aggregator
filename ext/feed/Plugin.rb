require 'feedzirra'

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

	# Aggregate feeds
	def aggregate_feeds
		action = get_action('feed_aggregation')
		time_until_aggregation = action.last_occurance

		if time_until_aggregation.nil? || time_until_aggregation > setting.sleep_timer
			Log.new(loggable: action, title: "Aggregating feeds.").save!
			setting.feeds.each{ |feed| aggregate_feed(feed, action)}
		else
			logger.info "Possible aggregation in #{setting.sleep_timer - time_until_aggregation} seconds."
		end
	end

	# Aggregate feed
	def aggregate_feed(feed_url, action)
		title = "Aggregating from #{feed_url}."
		logger.info title

		# Parse feed data.
		feed = Feedzirra::Feed.fetch_and_parse(feed_url)

		# Find message category, which belongs to this feed.
		message_category = MessageCategory.find_or_initialize_by(handle: Digest::MD5.hexdigest(feed.url))

		# Set action to this message category, if it's nil.
		if message_category.action.nil?
			message_category.action = action
		end

		# Set name of this message category.
		if message_category.name.nil? || message_category.name.empty? || message_category.name != feed.title
			message_category.name = feed.title
		end

		# Save message category, if it's necessery.
		unless message_category.persisted?
			message_category.save!
		end

		# Write log about activity.
		Log.new(loggable: message_category, title: title).save!

		# Parse entries to records and check, if the entry is already in the database.
		messages = []

		feed.entries.each do |entry|
			message = Message.find_or_initialize_by(handle: Digest::MD5.hexdigest(entry.url))
			message.message_category = message_category

			if message.published_at.nil? || message.published_at < entry.published
				message.published_at = entry.published
				message.summary = entry.summary
				message.content = entry.content
				message.title = entry.title
				message.reference_url = entry.url
			end

			if message.changed?
				messages << message
				logger.debug "Message is new or changed. It will be persisted soon."
			end
		end

		# Persist/update messages
		if messages.count > 0
			Message.transaction do
				messages.each do |m|
					m.save!
					logger.info "Persisted new/updated message (#{m.title})."
				end
			end
		end
	end
end