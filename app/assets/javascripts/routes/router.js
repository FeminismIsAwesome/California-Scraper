var app = angular.module('reportcard');
app.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    	$routeProvider.when('/', {
    		templateUrl: '/templates/index.html',
    		controller: 'ReportCardHomeController'
    	});
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