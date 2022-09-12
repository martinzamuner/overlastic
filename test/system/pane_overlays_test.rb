require "application_system_test_case"

class PaneOverlaysTest < ApplicationSystemTestCase
  test "basic pane overlay" do
    visit messages_path
    click_on "New message"

    fill_in "Content", with: "Test content"
    click_on "Create Message"

    assert_text "Test content"
  end

  test "pane overlay with args" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "Edit"

    assert_text "Edit message"
  end

  test "pane overlay with stack action" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "My message"

    assert_text "Message ##{message.id}"
    click_on "Edit (stack)"

    assert_text "Edit message"
    assert_selector "turbo-frame[id=overlay1]", visible: true
    assert_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay with replace_all action" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "My message"

    assert_text "Message ##{message.id}"
    click_on "Edit (replace_all)"

    assert_text "Edit message"
    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end
end
