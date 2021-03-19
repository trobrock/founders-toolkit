# frozen_string_literal: true

module FoundersToolkit::Monitoring
  module Statsdable
    extend ActiveSupport::Concern

    def statsd
      Rails.application.config.statsd
    end

    class_methods do
      def time(method_name)
        wrapper = Module.new do
          define_method(method_name) do |*args|
            statsd.time [self.class.name, method_name].join('.') do
              super(*args)
            end
          end
        end
        prepend wrapper
      end
    end
  end
end
