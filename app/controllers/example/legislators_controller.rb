class Example::LegislatorsController < ApplicationController

  def index

  end

  def show
    @legislator = Legislator.where(:last_name => params[:last_name]).first
    @legislatorVotes = VotingRecord.where(:legislator => @legislator)
  end

end
