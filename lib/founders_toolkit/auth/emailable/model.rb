# frozen_string_literal: true

module FoundersToolkit::Auth::Emailable::Model
  extend ActiveSupport::Concern

  included do
    begin
      require 'email_validator'
    rescue LoadError
      puts 'FoundersToolkit::Auth::Emailable requires the `email_validator` gem!'
      raise
    end
    validates :email,
              presence: true,
              email: { mode: :strict, require_fqdn: true },
              uniqueness: { case_sensitive: false }
  end
end
