# frozen_string_literal: true

RSpec.describe PixPayload do
  it "has a version number" do
    expect(PixPayload::VERSION).not_to be nil
  end
end
