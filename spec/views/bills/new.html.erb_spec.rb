require 'rails_helper'

RSpec.describe "bills/new", :type => :view do
  before(:each) do
    assign(:bill, Bill.new(
      :title => "MyString"
    ))
  end

  it "renders new bill form" do
    render

    assert_select "form[action=?][method=?]", bills_path, "post" do

      assert_select "input#bill_title[name=?]", "bill[title]"
    end
  end
end
