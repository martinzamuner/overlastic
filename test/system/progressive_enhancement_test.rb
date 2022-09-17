require "application_system_test_case"

class ProgressiveEnhancementTest < ApplicationSystemTestCase
  driven_by :rack_test

  test "overlay links load the whole page outside an overlay when JS is disabled" do
    visit root_path
    click_on "Dialog examples"

    assert_text "New article"

    refute_selector "#overlay1 overlastic-dialog"
  end

  test "overlay redirections load the whole page outside an overlay when JS is disabled" do
    article = Article.create! body: "My article"
    comment = article.comments.create! body: "My comment"

    visit edit_dialogs_article_comment_path(article, comment)
    fill_in "Body", with: "Test body"
    click_on "Update Comment"

    assert_text "Test body"

    refute_selector "#overlay1 overlastic-dialog"
  end

  test "forced renders load the whole page outside an overlay when JS is disabled" do
    visit root_path
    click_on "Open help in the first dialog"

    assert_text "Super helpful page for when you're in need of help."

    refute_selector "#overlay1 overlastic-dialog"
  end
end
