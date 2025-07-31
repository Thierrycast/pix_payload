# frozen_string_literal: true

require_relative "pix_payload/version"

module PixPayload
  class Generator
    def self.emv(id, value)
      length = value.length.to_s.rjust(2, '0')
      "#{id}#{length}#{value}"
    end
  end
end