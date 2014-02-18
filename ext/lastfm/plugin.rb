require 'lastfm'

require 'app/plugins/plugin_frame'

# Plugin to aggregate LastFM data
class LastfmPlugin < PluginFrame

	def initialize(plugin_model)
		super plugin_model

		@lastfm = Lastfm.new(setting.consumer_key, setting.consumer_secret)
		@lastfm.session = @lastfm.auth.get_session(token: setting.consumer_token)
	end

	def run
		followers_action = get_action('lastfm_follower_aggregation')
		if action_ready?(followers_action, setting.sleep_timer)
			aggregate_followers(followers_action)
		end
	end

	private

	# Aggregate followers
	def aggregate_followers(action)
		Log.new(loggable: action, title: "Aggregating LastFM followers.").save!
		
		followers = []

		@lastfm.user.get_friends(user: @lastfm.session['name']).each do |f|
			follower = Follower.find_or_initialize_by(username: f['id'].to_s)
			follower.name = f['name']
			follower.profile_url = f['url']
			follower.image_url = f['image'][2]['content']
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
end