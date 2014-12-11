require 'rails_helper'

feature "Static Pages" do

  given(:posts) { FactoryGirl.create_list(:post, 22) }
  given(:html_post) { FactoryGirl.create(:post, :html_note) }

  background do
  end

  # Here's a placeholder feature spec to use as an example, uses the default driver.
  scenario "/ should include the application name in its title" do
    visit root_path

    expect(page).to have_title "Instapost"
  end

  # Another contrived example, this one relies on the javascript driver.
  scenario "/ should show the first 20 posts" do
    posts
    visit root_path

    expect(page).to have_css '.post', count: PostsController::PICS_PER_PAGE
    expect(page).to have_css '.post .note', text: Post.order(created_at: :desc).first.note
    expect(page).to have_link 'More'
    expect(page).to have_css '[data-page=0]'
  end

  scenario "/ should show more posts when i click on 'more'", js: true do
    posts
    visit root_path
    click_on '#load-more'
    expect(page).to have_css '.post', count: PostsController::PICS_PER_PAGE * 2
    expect(page).to have_link 'More'
    expect(page).to have_css '[data-page=1]'
    click_on '#load-more'
    expect(page).to have_css '.post', count: posts.length
    expect(page).to_not have_link 'More'
  end

  scenario "/ should show html notes as html" do
    html_post
    visit root_path
    expect(page).to have_css '.post .note p'
  end

end
