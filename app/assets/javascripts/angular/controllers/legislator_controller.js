//= require angular/report-card
app.controller('LegislatorsController', ['$scope', 'LegislatorDataService','BillService', function($scope, LegislatorDataService,BillService) {
    LegislatorDataService.getLegislators().then(function(legislators) {
        return legislators.data.map(function(legislator) {
            legislator.fullName = legislator.first_name + " " + legislator.last_name;
            return legislator;
        });
    }).then(function(legislators) {
        $scope.legislators = legislators;
        var bills = BillService.getBillsForCard();
        return LegislatorDataService.getBillsForAllLegislators(bills).then(function(votes) {
            $scope.votes = votes.data;
        });
    });
}]);