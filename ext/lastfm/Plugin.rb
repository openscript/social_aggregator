require 'app/plugins/PluginFrame'

require 'lastfm'

class LastFm < PluginFrame

	def initialize(plugin_model)
		super plugin_model

		@lastfm = Lastfm.new(setting.consumer_key, setting.consumer_secret)

		if setting.consumer_token.empty?
			token = @lastfm.auth.get_token
			logger.warn "Grant api access via http://www.last.fm/api/auth?api_key=#{setting.consumer_key}&token=#{token}."
			logger.warn "Save the token key \"#{token}\" to the settings file!"
		end
		if !setting.consumer_token.empty? && setting.consumer_session.empty?
			begin
				@lastfm.session = @lastfm.auth.get_session(:token => setting.consumer_token)['key']
			rescue => e
				logger.warn "Grant api access via http://www.last.fm/api/auth?api_key=#{setting.consumer_key}&token=#{setting.consumer_token}."
			end

			logger.warn "Save the session key \"#{@lastfm.session}\" to the settings file!"
		end
	end

end