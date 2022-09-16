require "application_system_test_case"

class DialogOverlaysTest < ApplicationSystemTestCase
  test "dialog overlay without target" do
    visit root_path
    click_on "Open this page in a dialog"

    within("#overlay1 overlastic-dialog") do
      click_on "Dialog examples"
    end

    assert_text "New article"
    refute_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "dialog overlay with target _self" do
    visit dialogs_articles_path
    click_on "New article"

    within("#overlay1 overlastic-dialog") do
      fill_in "Body", with: "Test body"
      click_on "Create Article"

      assert_text "Thank you!"
      click_on "See all your articles"
    end

    assert_text "Test body"
    refute_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "dialog overlay with args" do
    article = Article.create! body: "My article"

    visit dialogs_articles_path
    click_on "Edit"

    within("#overlay1 overlastic-dialog") do
      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
  end

  test "dialog overlay with stack action" do
    article = Article.create! body: "My article"

    visit dialogs_articles_path
    click_on "My article"

    within("#overlay1 overlastic-dialog") do
      assert_text "Article ##{article.id}"
      click_on "Edit (stack)"
    end

    within("#overlay2 overlastic-dialog") do
      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    assert_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "dialog overlay with replace_last action" do
    article = Article.create! body: "My article"

    visit dialogs_articles_path
    click_on "My article"

    within("#overlay1 overlastic-dialog") do
      assert_text "Article ##{article.id}"
      click_on "Edit (replace_last)"

      assert_text "Edit article"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "dialog overlay being closed from the server" do
    article = Article.create! body: "My article"

    visit dialogs_articles_path
    click_on "Edit"

    within("#overlay1 overlastic-dialog") do
      click_on "Delete"
    end

    refute_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "dialog overlay redirecting into previous overlay after submission" do
    article = Article.create! body: "My article"

    visit dialogs_articles_path
    click_on "My article"

    within("#overlay1 overlastic-dialog") do
      click_on "New comment"
    end

    within("#overlay2 overlastic-dialog") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    within("#overlay1 overlastic-dialog") do
      assert_text "Test body"
    end

    assert_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end

  test "dialog overlay redirecting into the ether after submission" do
    article = Article.create! body: "My article"

    visit dialogs_article_path(article)
    click_on "New comment"

    within("#overlay1 overlastic-dialog") do
      fill_in "Body", with: "Test body"
      click_on "Create Comment"
    end

    assert_text "Test body"

    refute_selector "turbo-frame[id=overlay1]", visible: true
    refute_selector "turbo-frame[id=overlay2]", visible: true
  end
end
