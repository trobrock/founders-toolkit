# frozen_string_literal: true

require_relative '../util/lockable'

module FoundersToolkit::Jobs
  module LockedJob
    extend ActiveSupport::Concern

    included do
      include FoundersToolkit::Util::Lockable
      attr_accessor :current_lock
    end

    class_methods do
      def lock(ttl:, enqueue_ttl: 3_600_000)
        before_enqueue do |_job|
          enqueue_lock = locker.lock(enqueue_lock_key, enqueue_ttl)
          throw :abort unless enqueue_lock

          persist_lock_info(enqueue_lock)
        end

        before_perform do |_job|
          enqueue_lock = get_lock_info
          if enqueue_lock
            locker.unlock(enqueue_lock)
            delete_lock_info
          end
        end

        around_perform do |job, block|
          self.current_lock = locker.lock(lock_key, ttl)

          if current_lock
            begin
              block.call
            ensure
              locker.unlock(current_lock)
            end
          else
            self.class.set(wait: ttl / 1000 / 2).perform_later(*job.arguments)
          end
        end
      end
    end

    def extend_lock(ttl)
      self.current_lock = locker.lock(lock_key,
                                      ttl,
                                      extend: current_lock,
                                      extend_only_if_locked: true) || current_lock
    end

    private

    def persist_lock_info(lock_info)
      Resque.redis.set(lock_info_key, lock_info.to_json)
    end

    def get_lock_info
      info = Resque.redis.get(lock_info_key)
      return unless info

      JSON.parse(info).symbolize_keys
    end

    def delete_lock_info
      Resque.redis.del(lock_info_key)
    end

    def lock_info_key
      "locked_job:#{job_id}"
    end

    def enqueue_lock_key
      [self.class.name, 'enqueue'].concat(serialize['arguments']).join('-')
    end

    def lock_key
      [self.class.name].concat(serialize['arguments']).join('-')
    end
  end
end
