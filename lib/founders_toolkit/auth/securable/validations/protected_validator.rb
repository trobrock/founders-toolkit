# frozen_string_literal: true

module FoundersToolkit::Auth::Securable::Validations
  class ProtectedValidator < ActiveModel::EachValidator
    def initialize(options)
      super({ case_sensitive: true }.merge!(options))
      setup! options[:class]
    end

    def validate_each(record, attribute, _value)
      return if record.new_record?
      return unless attribute_changed?(record, attribute)
      return if authenticate?(record)

      human_attribute_name = record.class.human_attribute_name(attribute)
      record.errors.add(
        :current_password,
        "Your current password is required to update your #{human_attribute_name}"
      )
    end

    private

    def setup!(klass)
      klass.attr_accessor :current_password
    end

    def attribute_changed?(record, attribute)
      attribute = "#{attribute}_digest" if options[:secure]
      record.public_send("#{attribute}_changed?")
    end

    def authenticate?(record)
      return true if record.try(:reset_password_token?)

      fresh_record = record.class.find(record.id)
      fresh_record.authenticate(record.current_password)
    end

    module HelperMethods
      def validates_protected_attributes(*attr_names)
        validates_with ProtectedValidator, _merge_attributes(attr_names)
      end
    end
  end
end
