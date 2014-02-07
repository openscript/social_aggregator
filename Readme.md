![Banner](https://github.com/openscript/social_aggregator/wiki/res/banner.png)

Dear followers!

There are many social networks out there. This software aggregates information from different networks to one xml-stream, which you can reuse. For instance on your personal website to show some of your activity to your audience or as your personal news feed.

## Providers
Basically the system is designed to be extensible via plugins. It's shipped with the following ones:

### Social Networks
- Facebook (`facebook`)
- Google+ (`google_plus`)
- Twitter (`twitter`)
- LastFM (`lastfm`)
- YouTube - maybe later

### Other
- RSS feeds (`feed`)
  - dosen't work on Windows at the moment

## Outputs
xml and callbacks

## Usage
Right now the aggregator supports the following platform:
- Ruby 2.1 on Linux and Windows

Please write a bug report or feature requests to improve the software. Send pull requests to be an active user. Thank you very much!

### Installation
1. Set up `Ruby` or `JRuby` (real multithreading) and `RubyGems`
2. Get your version of the social aggregator and change to it's directory
3. Run `bundle install` to install all the necesserily gems
4. Run `rake install` to get the social aggregator ready
5. Set up and configure plugins/providers
6. Execute the `Aggregator.rb` (e. g. `ruby Aggregator.rb -h`) and have fun!

### Upgrade
If your copy is still linked with this git repository, then you can follow this two steps:

1. Run `git remote update` to update the Social Aggreator
2. Run `rake aggregator:migrate` to migrate the database to the updates version.

### Sensitive data
Please use file access restriction to protect your sensitive data:
- Plugin configuration files, which contain api keys
- Database, which contains all personal data

Please protect the REST API from foreign access.

### Tasks
The following rake tasks are defined:

`rake aggregator:[task]`

| task       | parameter        | description                 |
|:----------:|:---------------- |:----------------------------|
| `migrate`  | <code>[env=(development&#124;test&#124;production)]</code><br /> (default: `production`)<br /><code>[ver=(*version number*)]</code><br /> (default: last version) | Initialize/Migrate database |
| `install`  | <code>[env=(development&#124;test&#124;production)]</code><br /> (default: `production`)<br /><code>[ver=(*version number*)]</code><br /> (default: last version) | Set up the environment for aggregator |

### Run with built-in server
You can utilize the aggregator directly via commandline. It uses a built in webrick server in this case. It's planned that other servers can be used, but that is not implemented yet.

`aggregator.rb [arguments]`

| shortcut | parameter       | description                                             |
|:--------:|:--------------- |:------------------------------------------------------- |
| `-e`     | `--environment` | Select an environment (development, test or production) |
| `-q`     | `--quiet`       | No output to stdout                                     |
| `-v`     | `--verbose`     | Run verbosely                                           |
| `-c`     | `--console`     | Start a console session                                 |
| `-h`     | `--help`        | Show this message                                       |
|          | `--version`     | Show version                                            |

### Problems
Usually it's a good idea to have a look into the log files, especially the `tmp/log/aggregator.log` could be interesting, while the software is quite talkative. You should also consider to utilize the interactive ruby shell.

## Development
Please have a look into the [wiki](https://github.com/openscript/social_aggregator/wiki).

There is a built-in command line (IRB). You'll have access from there to:

- all models

### Documentation
You can generate the source code documentation anytime with `yardoc` from the document root. You'll find the generated documentation in `./doc/yard/`.

## Other stuff
Things, which need to be said!

### Note of thanks
Thanks to all users, who helped to improve the software!

- [Thanks for the icons, which are used in the banner.](http://www.apricum.net/2012/03/22/social-media-icons/)
- [Thanks for the font, which is used in the banner.](http://www.dafont.com/sansation.font)
- [Thanks for the twitter gem, which is used in the twitter plugin.](http://rubygems.org/gems/twitter)
- [Thanks for the feedzirra gem, which is used in the feed plugin.](http://rubygems.org/gems/feedzirra)
- [Thanks for the lastfm gem, which is used in the lastfm plugin.](http://rubygems.org/gems/lastfm)

### Copyright
This projected is licensed under the terms of the GPL v3 license. Please consult the license file for further information.

Copyright © 2013 - 2014 Robin Bühler