require "test_helper"

class ActionView::TestCase
  include Overlastic::OverlaysHelper
end

class Overlastic::NavigationHelperTest < ActionView::TestCase
  test "link_to_overlay without args" do
    assert_no_match "data-overlay-args", link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with args" do
    assert_match 'data-overlay-args="{&quot;title&quot;:&quot;Test dialog&quot;}"', link_to_overlay("Link", new_dialogs_article_path, overlay_args: { title: "Test dialog" })
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

  test "link_to_overlay without explicit action" do
    assert_match 'data-turbo-frame="overlay33"', link_to_overlay("Link", new_dialogs_article_path)
  end

  test "link_to_overlay with action replace_last" do
    assert_match 'data-turbo-frame="overlay32"', link_to_overlay("Link", new_dialogs_article_path, overlay_action: :replace_last)
  end

  test "link_to_overlay with action replace_all" do
    assert_match 'data-turbo-frame="overlay1"', link_to_overlay("Link", new_dialogs_article_path, overlay_action: :replace_all)
  end

  test "link_to_dialog" do
    assert_match 'data-overlay-type="dialog"', link_to_dialog("Link", new_dialogs_article_path)
  end
end
