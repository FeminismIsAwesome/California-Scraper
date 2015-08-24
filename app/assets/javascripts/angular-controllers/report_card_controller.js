var app = angular.module('reportcard');
app.controller('ReportCardHomeController', ['$scope', 'LegislatorDataService', 'BillService', '$location', function($scope, LegislatorDataService, BillService, $location) {
  $scope.$watch('selectedLegislator', function(legislator) {
    if (legislator) {
      var bills = BillService.getBillsForCard();
      var billFeelings = BillService.getBillOpinionsForCard();
      LegislatorDataService.getBillsForLegislator(bills, legislator).then(function(votes) {
        $scope.votes = votes.data;
        $scope.voteTotal = $scope.votes.reduce(function(memo, vote) {
          var voteWeight = 0;
          if (billFeelings[vote.bill_identity][vote.vote]) {
            voteWeight = 1;
          } else if (vote.vote === "noes") {
            // voteWeight = -1;
          }
          return memo + voteWeight;
        }, 0);
      });
    }
  });
  $scope.renderVoteAsGrade = function() {
    if ($scope.votes.length === 0) {
      return "";
    }
    var percentage = $scope.voteTotal / $scope.votes.length;
    if (percentage >= 0.9) {
      return "A";
    } else if (percentage >= 0.8) {
      return "B";
    } else if (percentage >= 0.7) {
      return "C";
    } else if (percentage >= 0.6) {
      return "D";
    } else {
      return "F";
    }
  }
  $scope.goToAllLegislators = function() {
    $location.path('/reportCard/all-legislators');
  }
  $scope.showSearchByName = function() {
    $scope.clearSearchBars();
    $scope.showSearchName = true;
  }
  $scope.clearSearchBars = function() {
   $scope.showSearchDistrict = false; 
   $scope.showSearchName = false;
   $scope.showZipCodeSearchbar = false;
  }
  $scope.showSearchByZipCode = function() {
    $scope.clearSearchBars();
    $scope.showZipCodeSearchbar = true;
  }
  $scope.showSearchByDistrict = function() {
    $scope.clearSearchBars();
    $scope.showSearchDistrict = true;
  }
}])