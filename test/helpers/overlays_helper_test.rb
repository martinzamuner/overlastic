require "test_helper"

class Overlastic::OverlaysHelperTest < ActionView::TestCase
  test "overlastic_tag without parameters" do
    assert_dom_equal '<overlastic data-overlay-target="_top" id="overlay1"></overlastic>', overlastic_tag
  end

  test "overlastic_tag with id" do
    assert_dom_equal '<overlastic data-overlay-target="_top" id="overlay13"></overlastic>', overlastic_tag(id: :overlay13)
  end

  test "overlastic_tag with block" do
    assert_match '<overlastic id="overlay32" data-overlay-target="_top">', overlastic_tag { tag.div "content" }
    assert_match '<overlastic id="overlay33" data-overlay-target="_top">', overlastic_tag { tag.div "content" }
  end

  test "current_overlay_name" do
    assert_equal :overlay32, current_overlay_name
  end

  test "overlay_number_from :overlay13" do
    assert_equal 13, overlay_number_from(:overlay13)
  end

  test "overlay_name_from :first" do
    assert_equal :overlay1, overlay_name_from(:first)
  end

  test "overlay_name_from :all" do
    assert_equal :overlay1, overlay_name_from(:all)
  end

  test "overlay_name_from :last" do
    assert_equal :overlay32, overlay_name_from(:last)
  end

  test "overlay_name_from :current" do
    assert_equal :overlay32, overlay_name_from(:current)
  end

  test "overlay_name_from :previous" do
    assert_equal :overlay31, overlay_name_from(:previous)
  end

  test "overlay_name_from :next" do
    assert_equal :overlay33, overlay_name_from(:next)
  end

  test "overlay_name_from :overlay13" do
    assert_equal :overlay13, overlay_name_from(:overlay13)
  end

  test "valid_overlay_name? with valid name" do
    assert valid_overlay_name?(:overlay1)
  end

  test "valid_overlay_name? with invalid name" do
    refute valid_overlay_name?(:overlay0)
  end
end
