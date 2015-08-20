var app = angular.module('reportcard');
function sortBills(bills) {
    return bills.sort(function(bill, otherBill) {
            var billTypeCompare = bill.billType.localeCompare(otherBill.billType);
            if(billTypeCompare === 0) {
                return parseInt(bill.billNumber) - parseInt(otherBill.billNumber);
            }
            else {
                return billTypeCompare;
            }
        });
}
app.controller('LegislatorsController', ['$scope', 'LegislatorDataService','BillService', function($scope, LegislatorDataService,BillService) {
    LegislatorDataService.getLegislators().then(function(legislators) {
        return legislators.data.map(function(legislator) {
            legislator.fullName = legislator.first_name + " " + legislator.last_name;
            return legislator;
        });
    }).then(function(legislators) {
        $scope.legislators = legislators;
        var bills = BillService.getBillsForCard();
        $scope.bills = sortBills(bills);
        return LegislatorDataService.getBillsForAllLegislators(bills).then(function(votes) {
            $scope.legislatorsWithVotes = votes.data.sort(function(legislatorWithVote, otherLegislatorWithVote) {
                var legislatorName = legislatorWithVote.legislator.last_name;
                var otherLegislatorName = otherLegislatorWithVote.legislator.last_name;
                return legislatorName.localeCompare(otherLegislatorName);
            }).map(function(legislatorWithVote) {
                var missingBillVotes = $scope.bills.filter(function(vote) {
                    var possiblyHavingBillVote = legislatorWithVote.votes.filter(function(targetVote) {
                        return targetVote.bill_number === vote.billNumber && targetVote.bill_type === vote.billType;
                    });
                    return possiblyHavingBillVote.length === 0;
                });
                missingBillVotes = missingBillVotes.map(function(billVote) {
                    billVote.notAccountedFor = true;
                    return billVote;
                });
                var billAndType = {};
                legislatorWithVote.votes.forEach(function(vote) {
                    if(billAndType[vote.bill_number + vote.bill_type]) {
                        bundledVote = {voting_location: vote.voting_location, vote: vote.vote}
                        var packagedVote = billAndType[vote.bill_number + vote.bill_type];
                        packagedVote.bundledVotes = packagedVote.bundledVotes.concat([bundledVote]);
                        billAndType[vote.bill_number + vote.bill_type] = packagedVote;
                    }
                    else {
                        bundledVote = {voting_location: vote.voting_location, vote: vote.vote}
                        vote.bundledVotes = [bundledVote];
                        billAndType[vote.bill_number + vote.bill_type] = vote;
                    }
                });
                var newVotes = [];
                Object.keys(billAndType).forEach(function(billIdentifier) {
                    newVotes.push(billAndType[billIdentifier]);
                });
                legislatorWithVote.votes = newVotes;
                legislatorWithVote.votes = missingBillVotes.concat(legislatorWithVote.votes).map(function(vote) {
                        vote.billNumber = vote.billNumber || vote.bill_number;
                        vote.billType = vote.billType || vote.bill_type;
                        return vote;
                    })
                legislatorWithVote.votes = sortBills(legislatorWithVote.votes);
                return legislatorWithVote;
            });
        });
    });
}]);