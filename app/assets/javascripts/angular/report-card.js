var app = angular.module('reportcard', ['ngRoute', 'ngResource']); 
app.controller('ReportCardHomeController', ['$scope', 'LegislatorDataService', 'BillService', function($scope, LegislatorDataService, BillService) {
    $scope.$watch('selectedLegislator', function(legislator) {
        if(legislator) {
           var bills = BillService.getBillsForCard();
            LegislatorDataService.getBillsForLegislator(bills, legislator).then(function(votes ) {
                $scope.votes = votes.data;
            }) 
        }
    });
}]);
app.service('BillService', ['$http', function($http) {
    return {
        getBillsForCard: function() {
            return [{
                billType: "AB",
                billNumber: "241"
            }, {
                billType: "AB",
                billNumber: "1516"
            },{
                billType: "AB",
                billNumber: "1522"
            },{
                billType: "AB",
                billNumber: "1579"
            },{
                billType: "AB",
                billNumber: "1266"
            },{
                billType: "AB",
                billNumber: "4"
            },{
                billType: "AB",
                billNumber: "60"
            },{
                billType: "AB",
                billNumber: "154"
            },{
                billType: "SB",
                billNumber: "154"
            },{
                billType: "SB",
                billNumber: "138"
            },{
                billType: "SB",
                billNumber: "1053"
            },{
                billType: "SB",
                billNumber: "1094"
            },{
                billType: "SB",
                billNumber: "1135"
            }]
        }
    }
}]);
app.service('LegislatorDataService', ['$http', function($http) {
    return {
        getLegislators: function() {
            return $http.get('/api/legislators');
        },
        getBillsForLegislator: function(bills, legislator) {
            return $http({
                url: '/api/legislators/votes',
                method: 'GET',
                params: {
                    "bills[]": bills.map(function(bill) {
                        return bill.billType + " " + bill.billNumber;
                    }),
                    legislator_name: legislator.last_name
                }
                });
        }
    }
}]);
app.controller('ReportCardViewController', ['$scope', function($scope) {

}]);
app.controller('ReportCardNewController', ['$scope', '$location', function($scope, $location) {
    $scope.add = function() {
        $location.path('/reportCard/1')
        console.log("Boop!");
    }
}]);
app.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    	$routeProvider.when('/', {
    		templateUrl: '/templates/index.html',
    		controller: 'ReportCardHomeController'
    	});

        $routeProvider.when('/reportCard/new', {
            templateUrl: '/templates/reportCard/new',
            controller: 'ReportCardNewController'
        })
        $routeProvider.when('/reportCard/:id', {
            templateUrl: '/templates/reportCard/show',
            controller: 'ReportCardViewController'
        });
        $routeProvider.otherwise({
            templateUrl: '/',
            controller: 'ReportCardHomeController'
        });
    }
]);