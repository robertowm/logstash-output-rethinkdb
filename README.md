# Logstash Plugin

[![Travis Build Status](https://travis-ci.org/robertowm/logstash-output-rethinkdb.svg)](https://travis-ci.org/robertowm/logstash-output-rethinkdb)

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

It is a Logstash output plugin to RethinkDB.  It supports the following configurations:

* host (type: string, default: "localhost")
* port (type: number, default: 28015)
* db (type: string, default: "stone")
* table(type: string, default: "table")

We tested at Logstash 2.3.1.  Before installing this plugin, you need to installing
the RethinkDB client.  The following steps details how to install it.  Consider that
Logstash is installed at */opt/logstash*.

* Set GEM_HOME as an environment variable with */opt/logstash/vendor/bundle/jruby/1.9*
* Run the commandline */opt/logstash/vendor/jruby/bin/jruby /opt/logstash/vendor/jruby/bin/gem install rethinkdb*
* Edit */opt/logstash/Gemfile* to include the line *gem "rethinkdb"*

More details at http://stackoverflow.com/questions/25984620/how-to-add-gems-into-logstash

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-output-rethinkdb", :path => "/your/local/logstash-output-rethinkdb"
```
- Install plugin
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Run Logstash with your plugin
```sh
bin/logstash -e 'output {rethinkdb {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-output-rethinkdb.gemspec
```
- Install the plugin from the Logstash home
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
