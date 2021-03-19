# frozen_string_literal: true

module FoundersToolkit::Util
  module Cacheable
    extend ActiveSupport::Concern

    class_methods do
      def cached(method_name)
        define_method("cached_#{method_name}") do |*args|
          Rails.cache.fetch([method_name, *args]) do
            __send__("unlocked_#{method_name}".to_sym, *args)
          end
        end

        alias_method "cached_#{method_name}".to_sym, method_name.to_sym
        alias_method method_name.to_sym, "cached_#{method_name}".to_sym
      end
    end
  end
end
