require "test_helper"

class Overlastic::HelpersInInitializersTest < ActionDispatch::IntegrationTest
  test "ActionController::Base has the helpers in place when initializers run" do
    assert_includes $dummy_ac_base_ancestors_in_initializers, Overlastic::Concerns::OverlayHandling
    assert_includes $dummy_ac_base_helpers_in_initializers, Overlastic::OverlaysHelper
    assert_includes $dummy_ac_base_helpers_in_initializers, Overlastic::NavigationHelper
  end
end
