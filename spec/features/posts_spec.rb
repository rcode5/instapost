require 'rails_helper'

feature "Static Pages" do

  given(:posts) { FactoryGirl.create_list(:post, 12) }
  given(:html_post) { FactoryGirl.create(:post, :html_note) }

  background do
  end

  # Here's a placeholder feature spec to use as an example, uses the default driver.
  scenario "/ should include the application name in its title" do
    visit root_path

    expect(page).to have_title "Instapost"
  end

  # Another contrived example, this one relies on the javascript driver.
  scenario "/ should show the first 10 posts" do
    posts
    visit root_path

    expect(page).to have_css '.post', count: 10
    expect(page).to have_css '.post .note', text: Post.order(created_at: :desc).first.note
    expect(page).to have_link 'More', href: 'posts/more'
  end

  scenario "/ should show html notes as html" do
    html_post
    visit root_path
    save_and_open_page
    expect(page).to have_css '.post .note p'
  end

end
