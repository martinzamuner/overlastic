require "test_helper"

class ActionView::TestCase
  include Overlastic::OverlaysHelper
end

class Overlastic::NavigationHelperTest < ActionView::TestCase
  test "link_to_overlay without args" do
    assert_no_match "data-overlay-args", link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with args" do
    assert_match "data-overlay-args=\"#{Base64.encode64({ title: "Test dialog" }.to_json)}\"", link_to_overlay("Link", new_dialogs_article_path, overlay_args: { title: "Test dialog" })
  end

  test "link_to_overlay without explicit target" do
    assert_no_match "data-overlay-target", link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with explicit target" do
    assert_match 'data-overlay-target="_self"', link_to_overlay("Link", new_dialogs_article_path, overlay_target: :_self)
  end

  test "link_to_overlay without explicit type" do
    assert_no_match "data-overlay-type", link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with explicit type" do
    assert_match 'data-overlay-type="dialog"', link_to_overlay("Link", new_dialogs_article_path, overlay_type: :dialog)
  end

  test "link_to_overlay without explicit overlay" do
    assert_match 'data-overlay-name="overlay33"', link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with overlay :last" do
    assert_match 'data-overlay-name="overlay32"', link_to_overlay("Link", new_dialogs_article_path, overlay: :last)
  end

  test "link_to_overlay with action :first" do
    assert_match 'data-overlay-name="overlay1"', link_to_overlay("Link", new_dialogs_article_path, overlay: :first)
  end

  test "link_to_dialog" do
    assert_match 'data-overlay-type="dialog"', link_to_dialog("Link", new_dialogs_article_path)
  end
end
