# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "rethinkdb"
include RethinkDB::Shortcuts

# An example output that does nothing.
class LogStash::Outputs::RethinkDB < LogStash::Outputs::Base
  config_name "rethinkdb"

  default :codec, "json"

  config :host,  :validate => :string, :default => "localhost"
  config :port,  :validate => :number, :default => 28015
  config :db,    :validate => :string, :default => "stone"
  config :table, :validate => :string, :default => "table"

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::RethinkDB
