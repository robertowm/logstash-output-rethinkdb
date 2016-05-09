# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# An example output that does nothing.
class LogStash::Outputs::RethinkDB < LogStash::Outputs::Base
  config_name "rethinkdb"

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::RethinkDB