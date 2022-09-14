require "test_helper"

class Overlastic::Concerns::OverlayHandlingTest < ActionDispatch::IntegrationTest
  test "renders inside overlay" do
    get new_dialogs_article_path, headers: { "Turbo-Frame" => "overlay31" }
    assert_match "overlay31", response.body
  end

  test "renders outside overlay" do
    get new_dialogs_article_path
    assert_no_match "overlay31", response.body
  end
end
