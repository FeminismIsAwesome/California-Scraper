var myApp = angular.module('reportcard', ['ngRoute', 'ngResource']); 
myApp.controller('ReportCardHomeController', ['$scope', function($scope) {
  $scope.greeting = 'Hola! This is Report Card Builder v0.1';
  $scope.thingies = ['a','list','of','objects'];
}]);
myApp.controller('ReportCardViewController', ['$scope', function($scope) {

}]);
myApp.controller('ReportCardNewController', ['$scope', '$location', function($scope, $location) {
    $scope.add = function() {
        $location.path('/reportCard/1')
        console.log("Boop!");
    }
}]);
myApp.config([
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