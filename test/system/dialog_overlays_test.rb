require "application_system_test_case"

class DialogOverlaysTest < ApplicationSystemTestCase
  test "basic dialog overlay" do
    visit articles_path
    click_on "New article"

    fill_in "Body", with: "Test body"
    click_on "Create Article"

    assert_text "Test body"
  end

  test "dialog overlay with args" do
    article = Article.create! body: "My article"

    visit articles_path
    click_on "Edit"

    assert_text "Edit article"
  end

  test "dialog overlay with stack action" do
    article = Article.create! body: "My article"

    visit articles_path
    click_on "My article"

    assert_text "Article ##{article.id}"
    click_on "Edit (stack)"

    assert_text "Edit article"
    assert_selector "turbo-frame[id=overlay1]", visible: true
    assert_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "dialog overlay with replace_last action" do
    article = Article.create! body: "My article"

    visit articles_path
    click_on "My article"

    assert_text "Article ##{article.id}"
    click_on "Edit (replace_last)"

    assert_text "Edit article"
    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end
end
