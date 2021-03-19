# frozen_string_literal: true

begin
  require 'redlock'
rescue LoadError
  puts 'FoundersToolkit::Util::Lockable requires `redlock` to be installed!'
  raise
end

module FoundersToolkit::Util
  module Lockable
    extend ActiveSupport::Concern

    def locker
      @locker ||= Redlock::Client.new([Redis.new])
    end

    def with_lock(name, ttl, &block)
      locker.lock!(name, ttl, &block)
    end

    class_methods do
      def locked(method_name, ttl, name_proc)
        define_method("locked_#{method_name}") do |*args|
          lock_name = instance_exec(&name_proc)
          lock = locker.lock(lock_name, ttl)
          return unless lock

          begin
            __send__("unlocked_#{method_name}".to_sym, *args)
          ensure
            locker.unlock(lock)
          end
        end

        alias_method "unlocked_#{method_name}".to_sym, method_name.to_sym
        alias_method method_name.to_sym, "locked_#{method_name}".to_sym
      end
    end
  end
end
