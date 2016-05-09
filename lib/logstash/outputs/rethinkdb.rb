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

    @codec.on_event(&method(:send_to_rethinkdb))
  end # def register

  public
  def receive(event)
    begin
      @codec.encode(event)
    rescue LocalJumpError
      raise
    rescue StandardError => e
      @logger.warn("Error encoding event", :exception => e, :event => event)
    end
  end # def event

  def send_to_rethinkdb(event, payload)
    r.table(@table)
      .insert(payload)
      .run(@conn)
  end
end # class LogStash::Outputs::RethinkDB
