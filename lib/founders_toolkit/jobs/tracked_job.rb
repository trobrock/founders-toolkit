# frozen_string_literal: true

module FoundersToolkit::Jobs
  module TrackedJob
    extend ActiveSupport::Concern

    included do
      include FoundersToolkit::Monitoring::Statsdable

      around_perform :update_stats
    end

    private

    def update_stats(&block)
      statsd.increment("active_job.#{self.class.queue_name}.#{self.class.name}.started")
      statsd.time("active_job.#{self.class.queue_name}.#{self.class.name}", &block)
      statsd.increment("active_job.#{self.class.queue_name}.#{self.class.name}.finished")
      update_queue_size_stats
    end

    def update_queue_size_stats
      Resque.queues.each do |name|
        statsd.gauge("active_job.queue_size.#{name}", Resque.size(name))
      end
    end
  end
end
