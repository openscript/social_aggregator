require 'koala'

require 'app/plugins/plugin_frame'

# Plugin to aggregate LastFM data
class FacebookPlugin < PluginFrame

	def initialize(plugin_model)
		super plugin_model

		@facebook = Koala::Facebook::API.new(setting.access_token)
	end

	def run
		posts_action = get_action('facebook_post_aggregation')
		if action_ready?(posts_action, setting.sleep_timer) 
			aggregate_posts(posts_action)
		end
	end

	private

	# Aggregate posts
	def aggregate_posts(action)
		page_object = @facebook.get_object("/#{setting.page_name}")

		# Find message category, which belongs to this facebook page.
		message_category = MessageCategory.find_or_initialize_by(handle: Digest::MD5.hexdigest(page_object['id'].to_s))

		# Set action to this message category, if it's nil.
		if message_category.action.nil?
			message_category.action = action
		end

		# Set name of this message category.
		if message_category.name.nil? || message_category.name.empty?
			message_category.name = page_object['name'].to_s
		end

		Log.transaction do
			# Save message category, if it's necessery.
			unless message_category.persisted?
				message_category.save!
			end

			# Write log about activity.
			Log.new(loggable: message_category, title: "Aggregating Facebook posts to #{message_category.name} category.").save!
			Log.new(loggable: action, title: "Aggregating Facebook posts.").save!
		end

		# Parse posts to records and check, if the tweet is already in the database.
		messages = []

		# Aggregate tweets
		@facebook.get_object("/#{setting.page_name}/posts").each do |post|
			message = Message.find_or_initialize_by(handle: Digest::MD5.hexdigest(post['id']))
			message.message_category = message_category

			post_created_at = DateTime.iso8601(post['created_time'])

			if message.published_at.nil? || message.published_at < post_created_at
				message.published_at = post_created_at
				message.content = post['message']
				message.reference_url = post['actions'].first['link']
			end

			if message.changed?
				messages << message
				logger.debug "Post is new or changed. It will be persisted soon."
			end
		end

		# Persist/update tweets
		if messages.count > 0
			Message.transaction do
				messages.each do |m|
					m.save!
					logger.info "Persisted new/updated message (#{m.handle})."
				end
			end
		end

	end
end