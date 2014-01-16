# Social Aggregator
Dear followers!

There are many social networks out there. This software aggregates information from different networks to one xml-stream, which you can reuse. For instance on your personal website to show some of your activity to your audience or as your personal news feed.

## Providers
Basically the system is designed to be extensible via plugins. It's shipped with the following ones:

### Social Networks
- Facebook
- YouTube
- Google+
- Twitter
- LastFM

### Other
- RSS feeds

## Outputs
xml and callbacks

## Usage
Please write a bug report, if errors occure. 

### Installation
1. Set up `Ruby` or `JRuby` (real multithreading) and `RubyGems`
2. Get your version of the social aggregator and change to it's directory
3. Run `bundle install` to install all the necesserily gems
4. Run `rake install` to get the social aggregator ready
5. Set up and configure plugins/providers
6. Execute the `Aggregator.rb` (e. g. `jruby Aggregator.rb -h`) and have fun!

### Tasks
The following rake tasks are defined:

`rake [task]`

| task       | parameter        | description                 |
|:----------:|:---------------- |:----------------------------|
| `migrate`  | <code>[env=(development&#124;test&#124;production)]</code><br /> (default: `production`)<br /><code>[ver=(*version number*)]</code><br /> (default: last version) | Initialize/Migrate database |


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