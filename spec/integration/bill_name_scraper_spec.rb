require "rails_helper"

RSpec.describe BillNameScraper, :type => :model do

  it "does the thing" do
    file = File.open("spec/integration/bill_list_example.txt")
    contents = file.read
    billHeaders = BillNameScraper.get_names_given(contents)
    puts billHeaders.map(&:billNumber)
    expect(billHeaders.length).to be > 10
  end

  it "gets the name and header given a simple format" do
    contents = "ACR 41  Chávez              Dr. Martin Luther King, Jr. Memorial Bridge.\nSB 42  Daly                Family Business Day."
    billHeaders = BillNameScraper.get_names_given(contents)
    expect(billHeaders.length).to be 2
    expect(billHeaders[0].billNumber).to eq("41")
    expect(billHeaders[0].billType).to eq("ACR")
    expect(billHeaders[1].billNumber).to eq("42")
    expect(billHeaders[1].billType).to eq("SB")
  end
end