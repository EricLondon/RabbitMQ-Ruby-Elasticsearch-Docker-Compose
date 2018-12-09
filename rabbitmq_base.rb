require 'bunny'
require 'elasticsearch'
require 'faker'

module ES
  module_function

  def client
    @client ||= Elasticsearch::Client.new url: es_url, log: true
  end

  def es_url
    "http://#{es_host}:9200"
  end

  def es_host
    ENV.fetch('ELASTICSEARCH_HOST', 'localhost')
  end
end

class RabbitmqBase
  def initialize
    begin
      create_connection
      create_channel
      create_queue
    rescue StandardError
      sleep 1
      retry
    end

    begin
      try_es_connection
    rescue StandardError
      sleep 1
      retry
    end
  end

  protected

  def try_es_connection
    ES.client.cluster.health wait_for_status: 'yellow'
  end

  def create_connection
    @connection = Bunny.new(hostname: rabbitmq_host)
    @connection.start
  end

  def create_channel
    @channel = @connection.create_channel
  end

  def create_queue
    @queue = @channel.queue(queue_name)
  end

  def queue_name
    ENV.fetch('QUEUE_NAME', 'worker_queue')
  end

  def rabbitmq_host
    ENV.fetch('RABBITMQ_HOST', 'localhost')
  end
end
