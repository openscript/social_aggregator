require 'twitter'

require 'app/plugins/PluginFrame'

# Plugin to aggregate twitter data
class TwitterPlugin < PluginFrame

	def initialize(plugin_model)
		super plugin_model

		@twitter = Twitter::REST::Client.new do |config|
			config.consumer_key        = setting.consumer_key
			config.consumer_secret     = setting.consumer_secret
			config.access_token        = setting.access_token
			config.access_token_secret = setting.access_token_secret
		end
	end

	def run
		followers_action = get_action('twitter_follower_aggregation')
		if action_ready?(followers_action, setting.follower_timer)
			aggregate_followers(followers_action)
		end

		tweets_action = get_action('twitter_tweet_aggregation')
		if action_ready?(tweets_action, setting.tweet_timer) 
			aggregate_tweets(tweets_action)
		end
	end

	private

	# Aggregate followers
	def aggregate_followers(action)
		Log.new(loggable: action, title: "Aggregating Twitter followers.").save!
		
		followers = []

		@twitter.followers.each do |f|
			follower = Follower.find_or_initialize_by(username: f.id.to_s)
			follower.name = f.name
			follower.profile_url = f.url.to_s
			follower.image_url = f.profile_image_url_https.to_s
			follower.action = action

			if follower.changed?
				followers << follower
				logger.debug "Follower is new or changed. It will be persisted soon."
			end
		end

		# Persist/update followers
		if followers.count > 0
			Follower.transaction do
				followers.each do |f|
					f.save!
					logger.info "Persisted new/updated follower (#{f.name})."
				end
			end
		end
	end

	# Aggregate tweets
	def aggregate_tweets(action)
		# Find message category, which belongs to this twitter messages.
		message_category = MessageCategory.find_or_initialize_by(handle: Digest::MD5.hexdigest(@twitter.user.id.to_s))

		# Set action to this message category, if it's nil.
		if message_category.action.nil?
			message_category.action = action
		end

		# Set name of this message category.
		if message_category.name.nil? || message_category.name.empty?
			message_category.name = @twitter.user.name
		end

		Log.transaction do
			# Save message category, if it's necessery.
			unless message_category.persisted?
				message_category.save!
			end

			# Write log about activity.
			Log.new(loggable: message_category, title: "Aggregating Twitter messages to #{message_category.name} category.").save!
			Log.new(loggable: action, title: "Aggregating Twitter messages.").save!
		end

		# Parse tweets to records and check, if the tweet is already in the database.
		messages = []

		# Aggregate tweets
		@twitter.user_timeline.each do |tweet|
			message = Message.find_or_initialize_by(handle: Digest::MD5.hexdigest(tweet.id.to_s))
			message.message_category = message_category

			if message.published_at.nil? || message.published_at < tweet.created_at
				message.published_at = tweet.created_at
				message.content = tweet.text
				message.title = tweet.text
				message.reference_url = tweet.url.to_s
			end

			if message.changed?
				messages << message
				logger.debug "Tweet is new or changed. It will be persisted soon."
			end
		end

		# Persist/update tweets
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