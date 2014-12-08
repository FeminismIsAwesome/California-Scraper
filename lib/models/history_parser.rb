class HistoryParser
  @@YEARS = [1900..2014]
  attr_accessor :billHistories
  def initialize
    @billHistories = {}
  end


  START_OF_BILL_RECORD = /^[A-z][A-z][A-z]\. \d.*/

  def isStartOfABillRecord(line)
    line.match(START_OF_BILL_RECORD)
  end

  def addCurrentInformationToLineAndRestartText(line)
    @lines.push(@currentText) unless @currentText == nil || @currentText == ""
    @currentText = line
  end
  def billHistoriesFor(historyLines)
    billYear = /\d\d\d\d/
    years = historyLines.scan(billYear)
    billHistoriesByYear = historyLines.split(billYear)[1..years.length+1]
    billHistoriesByYear = billHistoriesByYear.map {|billHistory|
      billHistory = cleanup_lines(billHistory)
      billHistory.scan(START_OF_BILL_RECORD)
    }
    years.each_with_index { |year, index|
      billHistories[year] = billHistoriesByYear[index]
    }
    billHistories
  end

  def cleanup_lines(billHistory)
    billHistory.split("\n").map { |historyLine|
      if (isStartOfABillRecord(historyLine))
        historyLine = "\n" + historyLine
        historyLine
      else
        historyLine
      end
    }.reduce(:+)
  end



end