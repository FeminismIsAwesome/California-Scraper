require 'rails_helper'

RSpec.describe "bills/show", :type => :view do
  before(:each) do
    @bill = assign(:bill, Bill.create!(
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
