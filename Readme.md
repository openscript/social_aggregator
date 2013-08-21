# Social Aggregator
Dear followers!

There are many social networks out there. This software aggregates information from different networks to one xml-stream, which you can reuse for instance on your personal website to show some of your activity to your audience.

## Sources
Basically the system is designed to be extensible via plugins. It's shipped with the following plugins:

### Networks
- Facebook
- YouTube
- Google+
- Twitter
- LastFM

### Others
- RSS feeds

## Outputs
xml and callbacks

## Installation
1. Set up `Ruby` or `JRuby` and `RubyGems`
2. Run `rake install`
3. Execute the `Aggregator.rb` (e. g. `jruby Aggregator.rb -h`)

## Usage

### Problems
Usually it's a good idea to have a look into the log files, especially the `tmp/log/aggregator.log` could be interesting, while the software is quite talkative. 

## Development
There is a prepared command line (IRB) built in.