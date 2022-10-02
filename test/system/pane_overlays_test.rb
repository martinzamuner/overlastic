require "application_system_test_case"

class PaneOverlaysTest < ApplicationSystemTestCase
  test "pane overlay without target" do
    visit root_path
    click_on "Open this page in a new pane"

    within("#overlay1 > div") do
      click_on "Pane examples"
    end

    refute_selector "overlastic[id=overlay1]", visible: true

    click_on "New article"

    assert_selector "overlastic[id=overlay1]", visible: true
  end

  test "dialog overlay with target _self" do
    visit panes_articles_path
    click_on "New article"

    within("#overlay1 > div") do
      fill_in "Body", with: "Test body"
      click_on "Create Article"

      assert_text "Thank you!"
      click_on "See all your articles"
    end

    assert_text "Test body"
    refute_selector "overlastic[id=overlay1]", visible: true
  end

  test "pane overlay with args" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "Edit"

    within("#overlay1 > div") do
      assert_text "Edit article"
    end

    assert_selector "overlastic[id=overlay1]", visible: true
  end

  test "pane overlay with stack action" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 > div") do
      assert_text "Article ##{article.id}"
      click_on "Edit (stack)"
    end

    within("#overlay2 > div") do
      assert_text "Edit article"
    end

    assert_selector "overlastic[id=overlay1]", visible: true
    assert_selector "overlastic[id=overlay2]", visible: true
  end

  test "pane overlay with overlay :first" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 > div") do
      assert_text "Article ##{article.id}"
      click_on "Edit (inside first)"

      assert_text "Edit article"
    end

    assert_selector "overlastic[id=overlay1]", visible: true
    refute_selector "overlastic[id=overlay2]", visible: true
  end

  test "pane overlay being closed from the server" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "Edit"

    within("#overlay1 > div") do
      click_on "Delete"
    end

    within("#flash-messages") do
      assert_text "Deleted!"
    end

    refute_selector "overlastic[id=overlay1]", visible: true
    refute_selector "overlastic[id=overlay2]", visible: true
  end

  test "pane overlay redirecting into previous overlay after submission" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 > div") do
      click_on "New comment"
    end

    within("#overlay2 > div") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    within("#flash-messages") do
      assert_text "Created!"
    end

    within("#overlay1 > div") do
      assert_text "Test body"
    end

    assert_selector "overlastic[id=overlay1]", visible: true
    refute_selector "overlastic[id=overlay2]", visible: true
  end

  test "pane overlay redirecting into the ether after submission" do
    article = Article.create! body: "My article"

    visit panes_article_path(article)
    click_on "New comment"

    within("#overlay1 > div") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    within("#flash-messages") do
      assert_text "Created!"
    end

    assert_text "Test body"

    refute_selector "overlastic[id=overlay1]", visible: true
    refute_selector "overlastic[id=overlay2]", visible: true
  end

  test "pane overlay forced by render" do
    visit root_path
    click_on "Open this page in a new pane"

    within("#overlay1 > div") do
      click_on "Open this page in a new pane"
    end

    within("#overlay2 > div") do
      click_on "Open help in the first pane"
    end

    within("#overlay1 > div") do
      assert_text "Super helpful page for when you're in need of help."
    end

    assert_selector "overlastic[id=overlay1]", visible: true
    refute_selector "overlastic[id=overlay2]", visible: true
  end
end
