require 'rails_helper'


describe Api::BillsController do

  let!(:bill) {Bill.create(billNumber: "1", billType: "AB")}
  let!(:bill2) {Bill.create(billNumber: "1", billType: "SB")}
  let!(:bill3) {Bill.create(billNumber: "2", billType: "AJR")}

  it "should get a list of all bills" do
    get :index, format: :json
    expect(json.length).to eq(3)
  end

  it "should get a list of all bills matching the bill number" do
    get :show, id: "1", format: :json
    expect(json.length).to eq(2)
  end

end