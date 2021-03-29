# frozen_string_literal: true

begin
  require 'ratelimit'
rescue LoadError
  puts 'FoundersToolkit::Util::RateLimitable requires the `ratelimit` gem!'
  raise
end

begin
  require 'retryable'
rescue LoadError
  puts 'FoundersToolkit::Util::RateLimitable requires the `retryable` gem!'
  raise
end

module FoundersToolkit::Util
  module RateLimitable
    extend ActiveSupport::Concern

    included do
      include FoundersToolkit::Monitoring::Statsdable
    end

    class_methods do
      def rate_limiter(name, key:, threshold:, interval:, retry_from: [])
        limiter_name = "#{name}_limiter"
        define_method(limiter_name) do |&block|
          limiter = instance_variable_get("@#{limiter_name}".to_sym)
          limiter ||= instance_variable_set("@#{limiter_name}".to_sym, Ratelimit.new(name))

          while limiter.exceeded?(__send__(key), threshold: threshold, interval: interval)
            statsd.increment ['thottled', limiter_name].join('.')
            sleep 5
          end

          result = statsd.time(['retryable', limiter_name].join('.')) do
            Retryable.retryable(tries: 3, on: retry_from) { block.call }
          end
          limiter.add __send__(key)
          result
        end
      end
    end
  end
end
