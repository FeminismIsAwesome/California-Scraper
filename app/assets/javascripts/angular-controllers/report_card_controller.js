var app = angular.module('reportcard');
app.controller('ReportCardHomeController', ['$scope', 'LegislatorDataService', 'BillService', '$location', function($scope, LegislatorDataService, BillService, $location) {
    $scope.$watch('selectedLegislator', function(legislator) {
        if(legislator) {
           var bills = BillService.getBillsForCard();
            LegislatorDataService.getBillsForLegislator(bills, legislator).then(function(votes ) {
                $scope.votes = votes.data;
            }); 
        }
    });
    $scope.goToAllLegislators = function() {
        $location.path('/reportCard/all-legislators');
    }
}]);