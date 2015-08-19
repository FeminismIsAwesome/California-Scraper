var app = angular.module('reportcard', ['ngRoute', 'ngResource']); 
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
        $routeProvider.when('/reportCard/all-legislators', {
            templateUrl: '/templates/legislators/all',
            controller: 'LegislatorsController'
        });
        $routeProvider.otherwise({
            templateUrl: '/',
            controller: 'ReportCardHomeController'
        });
    }
]);