require "test_helper"

class Overlastic::OverlaysHelperTest < ActionView::TestCase
  test "overlastic_tag without block" do
    assert_dom_equal '<turbo-frame id="overlay1" target="_top"></turbo-frame>', overlastic_tag
  end

  test "overlastic_tag with block" do
    assert_match '<turbo-frame id="overlay32">', overlastic_tag { tag.div "content" }
    assert_match '<turbo-frame id="overlay33" target="_top">', overlastic_tag { tag.div "content" }
  end

  test "current_overlay_name" do
    assert_equal :overlay32, current_overlay_name
  end

  test "next_overlay_name" do
    assert_equal :overlay33, next_overlay_name
  end

  test "render_overlay without explicit locals" do
    assert_match "<div>content</div>", render_overlay { tag.div "content" }
  end

  test "render_overlay with explicit locals" do
    assert_match "Test dialog", render_overlay(title: "Test dialog") { tag.div "content" }
  end
end
