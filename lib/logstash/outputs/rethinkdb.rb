# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "logstash/timestamp"
require 'time'
require "rethinkdb"
include RethinkDB::Shortcuts

# An example output that does nothing.
class LogStash::Outputs::RethinkDB < LogStash::Outputs::Base
  config_name "rethinkdb"

  config :host,  :validate => :string, :default => "localhost"
  config :port,  :validate => :number, :default => 28015
  config :db,    :validate => :string, :default => "stone"
  config :table, :validate => :string, :default => "table"

  public
  def register
    begin
      @conn = r.connect(
        :host => @host,
        :port => @port
      )
    rescue Exception => err
      logger.error "Cannot connect to RethinkDB database #{@host}:#{@port} (#{err.message})"
      Process.exit(1)
    end

    begin
      r.db_create(@db).run(@conn)
    rescue RethinkDB::RqlRuntimeError => err
      logger.info "Database `#{@db}` already exists."
    end

    begin
      r.db(@db).table_create(@table).run(@conn)
    rescue RethinkDB::RqlRuntimeError => err
      logger.info "Table `#{@db}.#{@table}` already exists."
    end
  end # def register

  public
  def receive(event)
    obj = format_event(event)
    r.db(@db)
      .table(@table)
      .insert(obj, :conflict => "replace")
      .run(@conn)
  end # def event

  def format_event(event)
    Hash[event.to_hash.map{ |k, v| [k, format_value(v)] }]
  end

  def format_value(value)
    case value
    when LogStash::Timestamp
      Time.parse(value.to_iso8601)
    when BigDecimal
      value.to_f()
    when String
      if value !~ /^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/
        value
      else
        Time.parse(value)
      end
    else
      value
    end
  end # def formatValue
end # class LogStash::Outputs::RethinkDB
