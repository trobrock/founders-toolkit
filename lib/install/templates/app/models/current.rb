# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  include FoundersToolkit::Auth::Securable::CurrentAttributes
end
