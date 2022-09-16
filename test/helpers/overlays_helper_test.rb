require "test_helper"

class Overlastic::OverlaysHelperTest < ActionView::TestCase
  test "overlastic_tag without parameters" do
    assert_dom_equal '<turbo-frame data-overlay-target="_top" id="overlay1"></turbo-frame>', overlastic_tag
  end

  test "overlastic_tag with id" do
    assert_dom_equal '<turbo-frame data-overlay-target="_top" id="overlay13"></turbo-frame>', overlastic_tag(id: :overlay13)
  end

  test "overlastic_tag with block" do
    assert_match '<turbo-frame data-overlay-target="_top" id="overlay32">', overlastic_tag { tag.div "content" }
    assert_match '<turbo-frame data-overlay-target="_top" id="overlay33">', overlastic_tag { tag.div "content" }
  end

  test "current_overlay_name" do
    assert_equal :overlay32, current_overlay_name
  end

  test "next_overlay_name" do
    assert_equal :overlay33, next_overlay_name
  end

  test "valid_overlay_name? with valid name" do
    assert valid_overlay_name?(:overlay1)
  end

  test "valid_overlay_name? with invalid name" do
    refute valid_overlay_name?(:overlay0)
  end

  test "render_overlay without explicit locals" do
    assert_match "<div>content</div>", render_overlay { tag.div "content" }
  end

  test "render_overlay with explicit locals" do
    assert_match "Test dialog", render_overlay(title: "Test dialog") { tag.div "content" }
  end
end
