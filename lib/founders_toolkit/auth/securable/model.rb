# frozen_string_literal: true

module FoundersToolkit::Auth::Securable::Model
  extend ActiveSupport::Concern

  included do
    include FoundersToolkit::Auth::Emailable::Model
    extend FoundersToolkit::Auth::Securable::Validations::ProtectedValidator::HelperMethods

    validates_protected_attributes :email
    validates_protected_attributes :password, secure: true

    has_secure_password
  end
end
