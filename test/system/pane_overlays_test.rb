require "application_system_test_case"

class PaneOverlaysTest < ApplicationSystemTestCase
  test "basic pane overlay" do
    visit messages_path
    click_on "New message"

    within("#overlay1") do
      fill_in "Content", with: "Test content"
      click_on "Create Message"
    end

    assert_text "Test content"
    refute_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "pane overlay with args" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "Edit"

    within("#overlay1") do
      assert_text "Edit message"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "pane overlay with stack action" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "My message"

    within("#overlay1") do
      assert_text "Message ##{message.id}"
      click_on "Edit (stack)"
    end

    within("#overlay2") do
      assert_text "Edit message"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    assert_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay with replace_all action" do
    message = Message.create! content: "My message"

    visit messages_path
    click_on "My message"

    within("#overlay1") do
      assert_text "Message ##{message.id}"
      click_on "Edit (replace_all)"

      assert_text "Edit message"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end
end
