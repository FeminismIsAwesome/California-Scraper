require 'rails_helper'

RSpec.describe "bills/index", :type => :view do
  before(:each) do
    assign(:bills, [
      Bill.create!(
        :title => "Title"
      ),
      Bill.create!(
        :title => "Title"
      )
    ])
  end

  it "renders a list of bills" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
