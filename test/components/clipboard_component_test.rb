# frozen_string_literal: true

require 'test_helper'

class ClipboardComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    assert_match(
      %(Hello, components!),
      render_inline(ClipboardComponent.new(value: 'Hello, components!')).to_html
    )
  end
end
