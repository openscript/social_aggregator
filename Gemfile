source 'https://rubygems.org'

gem 'bundler', '~> 1.5.2'
gem 'rake', '>= 10'
gem 'celluloid'
gem 'timers'
gem 'webrick'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'settingslogic'
gem 'haml', '>= 4'
gem 'awesome_print'
gem 'tzinfo-data'

# platform switch
if RUBY_PLATFORM =~ /java/ #jruby
	gem 'activerecord-jdbcsqlite3-adapter'
	gem 'activerecord'
	gem 'activesupport'
	
	group :development do
		gem 'ruby-debug'
	end
else # ruby
	#gem 'sqlite3'
	gem 'pg'

	gem 'activerecord', '>= 4'
	gem 'activesupport', '>= 4'
	gem 'database_cleaner'

	group :development do
		gem 'byebug'
	end
end

group :test do
	gem 'rspec'
end

group :development do
	gem 'yard'
end

# plugin dependencies 

# Twitter
gem 'twitter', '~> 5.6.0' # https://rubygems.org/gems/twitter

# Facebook
gem 'koala'

# Google Plus
gem 'google_plus'

# LastFm
gem 'lastfm' # https://rubygems.org/gems/lastfm

# Feed
unless RUBY_PLATFORM =~ /java/ #ruby
	gem 'feedzirra' # Curb is not available for jruby, so this gem won't work with jruby.
end