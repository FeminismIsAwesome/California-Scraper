require "rails_helper"

RSpec.describe BillNameScraper, :type => :model do

  it "reads the for 2013-2014 year appropriately" do
    file = File.open("spec/integration/bill_list_example.txt")
    contents = file.read
    billHeaders = BillNameScraper.get_names_given(contents)
    expect(billHeaders.length).to be > 10
    acrs = billHeaders.select{|bill| bill.billType == "ACR"}
    expect(acrs.length).to be 175
    abs = billHeaders.select{|bill| bill.billType == "AB"}
    expect(abs.length).to be 2766

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

  it "gets the name and header given a more complex format" do
    contents = "ACR 94  Rodriguez           Emergency services: active shooter incidents. \n
SB 90  Gomez               California Community Colleges: part-time faculty\n and classified employees.
ACR 96  Olsen               The 150th anniversary of the California State \n Park System."
    billHeaders = BillNameScraper.get_names_given(contents)
    expect(billHeaders.length).to be 3
    expect(billHeaders[0].billNumber).to eq("94")
    expect(billHeaders[0].billType).to eq("ACR")
    expect(billHeaders[1].billNumber).to eq("90")
    expect(billHeaders[1].billType).to eq("SB")
    expect(billHeaders[2].billNumber).to eq("96")
    expect(billHeaders[2].billType).to eq("ACR")
  end

end