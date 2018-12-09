#!/usr/bin/env ruby

require_relative 'rabbitmq_base'

class Producer < RabbitmqBase
  def start
    message = 'create_person'
    1_000.times { @queue.publish(message, persistent: true) }
  end
end

Producer.new.start
