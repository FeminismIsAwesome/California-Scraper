require 'rails_helper'

RSpec.describe "Bills", :type => :request do
  describe "GET /bills" do
    it "works! (now write some real specs)" do
      get bills_path
      expect(response.status).to be(200)
    end
  end
end
