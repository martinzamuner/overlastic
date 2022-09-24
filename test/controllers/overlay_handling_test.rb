require "test_helper"

class Overlastic::Concerns::OverlayHandlingTest < ActionDispatch::IntegrationTest
  test "close_overlay with notice inside overlay" do
    get close_path, headers: { "Overlay-Enabled" => "1", "Overlay-Name" => "overlay31" }
    assert_match "overlay31", response.body
    assert_match "Closed!", response.body
  end

  test "close_overlay with notice outside overlay" do
    get close_path, headers: { "Overlay-Enabled" => "1" }
    assert_match "overlay1", response.body
    assert_match "Closed!", response.body
  end

  test "renders inside overlay" do
    get new_dialogs_article_path, headers: { "Overlay-Enabled" => "1", "Overlay-Name" => "overlay31" }
    assert_match "overlay31", response.body
  end

  test "renders outside overlay" do
    get new_dialogs_article_path
    assert_no_match "overlay31", response.body
  end
end
