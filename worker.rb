#!/usr/bin/env ruby

require_relative 'rabbitmq_base'

class Worker < RabbitmqBase
  def start
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      if WorkerMethods.public_methods.include?(body.to_sym)
        WorkerMethods.send(body)
      else
        raise 'Worker method not found'
      end
    end
  end

  module WorkerMethods
    module_function

    def create_person
      person = {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email
      }
      ES.client.create index: 'people',
                       type: 'person',
                       body: person
      puts "Job processed by worker: #{hostname}"
    end

    def hostname
      @hostname ||= `hostname`.strip
    end
  end
end

Worker.new.start
