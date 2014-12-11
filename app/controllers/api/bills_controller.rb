class Api::BillsController < ApplicationController
  respond_to :json

  def index
   respond_with Bill.all
  end

  def show
    respond_with Bill.where(:billNumber => params[:id])
  end
end