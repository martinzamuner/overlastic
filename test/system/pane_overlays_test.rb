require "application_system_test_case"

class PaneOverlaysTest < ApplicationSystemTestCase
  test "dialog overlay with target _self" do
    visit panes_articles_path
    click_on "New article"

    within("#overlay1 overlastic-pane") do
      fill_in "Body", with: "Test body"
      click_on "Create Article"

      assert_text "Thank you!"
      click_on "See all your articles"
    end

    assert_text "Test body"
    refute_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "pane overlay with args" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "Edit"

    within("#overlay1 overlastic-pane") do
      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "pane overlay with stack action" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 overlastic-pane") do
      assert_text "Article ##{article.id}"
      click_on "Edit (stack)"
    end

    within("#overlay2 overlastic-pane") do
      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    assert_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay with replace_all action" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 overlastic-pane") do
      assert_text "Article ##{article.id}"
      click_on "Edit (replace_all)"

      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay being closed from the server" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "Edit"

    within("#overlay1 overlastic-pane") do
      click_on "Delete"
    end

    refute_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay redirecting into previous overlay after submission" do
    article = Article.create! body: "My article"

    visit panes_articles_path
    click_on "My article"

    within("#overlay1 overlastic-pane") do
      click_on "New comment"
    end

    within("#overlay2 overlastic-pane") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    within("#overlay1 overlastic-pane") do
      assert_text "Test body"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "pane overlay redirecting into the ether after submission" do
    article = Article.create! body: "My article"

    visit panes_article_path(article)

    click_on "New comment"

    within("#overlay1 overlastic-pane") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    assert_text "Test body"

    refute_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end
end
