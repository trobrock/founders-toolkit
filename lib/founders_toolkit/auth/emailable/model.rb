# frozen_string_literal: true

module FoundersToolkit::Auth::Emailable::Model
  extend ActiveSupport::Concern

  included do
    require 'email_validator'
    validates :email,
              presence: true,
              email: { mode: :strict, require_fqdn: true },
              uniqueness: { case_sensitive: false }
  end
end
