# frozen_string_literal: true

require 'active_support/concern'

module FoundersToolkit::Auth
  require_relative 'auth/securable'
  require_relative 'auth/emailable'
  require_relative 'auth/confirmable'
  require_relative 'auth/recoverable'
end
