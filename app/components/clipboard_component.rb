# frozen_string_literal: true

class ClipboardComponent < ViewComponent::Base
  attr_reader :value

  def initialize(value:)
    @value = value
  end
end
