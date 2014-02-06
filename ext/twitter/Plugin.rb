require 'twitter'

require 'app/plugins/PluginFrame'

# Plugin to aggregate twitter data
class Twitter < PluginFrame

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
		aggregate_followers
		aggregate_tweets
	end

	private

	# Aggregate followers
	def aggregate_followers
		action = get_action('twitter_follower_aggregation')
		time_until_aggregation = action.last_occurance

		if time_until_aggregation < setting.follower_timer
			logger.info "Possible aggregation in #{setting.follower_timer - time_until_aggregation} seconds."
			return
		end

		Log.new(loggable: action, title: "Aggregating Twitter followers.").save!
		
		followers = []

		@twitter.followers.each do |f|
			follower = Follower.find_or_initialize_by(username: f.user_id)
		end

		# Persist/update followers
		if followers.count > 0
			Follower.transaction do
				followers.each do |f|
					f.save!
					logger.info "Persisted new/updated follower (#{f.title})."
				end
			end
		end
	end

	# Aggregate tweets
	def aggregate_tweets
	end
end