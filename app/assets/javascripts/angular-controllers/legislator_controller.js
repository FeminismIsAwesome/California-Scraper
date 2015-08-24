var app = angular.module('reportcard');
function sortBills(bills) {
  return bills.sort(function(bill, otherBill) {
    var billTypeCompare = bill.billType.localeCompare(otherBill.billType);
    if (billTypeCompare === 0) {
      return parseInt(bill.billNumber) - parseInt(otherBill.billNumber);
    } else {
      return billTypeCompare;
    }
  });
}
function sortByLastName(legislatorWithVote, otherLegislatorWithVote) {
  var legislatorName = legislatorWithVote.legislator.last_name;
  var otherLegislatorName = otherLegislatorWithVote.legislator.last_name;
  return legislatorName.localeCompare(otherLegislatorName);
}
function getMissingVotesGiven(bills, votes) {
  var missingBillVotes = bills.filter(function(vote) {
    var possiblyHavingBillVote = votes.filter(function(targetVote) {
      return targetVote.bill_number === vote.billNumber && targetVote.bill_type === vote.billType;
    });
    return possiblyHavingBillVote.length === 0;
  });
  missingBillVotes = missingBillVotes.map(function(billVote) {
    billVote.notAccountedFor = true;
    return billVote;
  });
  return missingBillVotes;
}
function parseVotes(votes) {
  return votes.map(function(vote) {
    vote.billNumber = vote.billNumber || vote.bill_number;
    vote.billType = vote.billType || vote.bill_type;
    return vote;
  })
}
function removeDuplicates(votes) {
  var billAndType = {};
  votes.forEach(function(vote) {
    if (billAndType[vote.bill_number + vote.bill_type]) {
      bundledVote = {
        voting_location: vote.voting_location,
        vote: vote.vote
      }
      var packagedVote = billAndType[vote.bill_number + vote.bill_type];
      packagedVote.bundledVotes = packagedVote.bundledVotes.concat([bundledVote]);
      billAndType[vote.bill_number + vote.bill_type] = packagedVote;
    } else {
      bundledVote = {
        voting_location: vote.voting_location,
        vote: vote.vote
      }
      vote.bundledVotes = [bundledVote];
      billAndType[vote.bill_number + vote.bill_type] = vote;
    }
  });
  var newVotes = [];
  Object.keys(billAndType).forEach(function(billIdentifier) {
    newVotes.push(billAndType[billIdentifier]);
  });
  return newVotes;
}
app.controller('LegislatorsController', ['$scope', 'LegislatorDataService', 'BillService', "$location", function($scope, LegislatorDataService, BillService, $location) {
  $scope.returnToHome = function() {
    $location.path('/');
  }
  function organizeVotes(legislatorWithVote) {
    var missingBillVotes = getMissingVotesGiven($scope.bills, legislatorWithVote.votes);
    var billAndType = {};
    legislatorWithVote.votes = removeDuplicates(legislatorWithVote.votes);
    legislatorWithVote.votes = parseVotes(missingBillVotes.concat(legislatorWithVote.votes));
    legislatorWithVote.votes = sortBills(legislatorWithVote.votes);
    return legislatorWithVote;
  }

  $scope.loading = true;
  LegislatorDataService.getLegislators().then(function(legislators) {
    $scope.legislators = legislators;
    var bills = BillService.getBillsForCard();
    $scope.bills = sortBills(bills);
    return LegislatorDataService.getBillsForAllLegislators(bills).then(function(votes) {
      $scope.legislatorsWithVotes = votes.data.sort(sortByLastName).map(organizeVotes);
      $scope.loading = false;
    });
  });
}]);