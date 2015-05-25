require 'spec_helper.rb'

feature "Adding a new report card", js: true do
  scenario "Initialize Report Card" do
    visit '/'
    expect(page).to have_content("Hola! This is Report Card Builder v0.1")
  end
end
