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
		aggregate_tweets
	end

	private

	# Aggregate followers
	def aggregate_followers(action)
		Log.new(loggable: action, title: "Aggregating Twitter followers.").save!
		
		followers = []

		@twitter.followers.each do |f|
			follower = Follower.find_or_initialize_by(username: f.id)
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
	def aggregate_tweets
	end
end