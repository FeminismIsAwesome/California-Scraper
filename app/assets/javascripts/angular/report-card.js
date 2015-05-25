var myApp = angular.module('reportcard', ['ngRoute', 'ngResource']); 
myApp.controller('ReportCardHomeController', ['$scope', function($scope) {
  $scope.greeting = 'Hola! This is Report Card Builder v0.1';
  $scope.thingies = ['a','list','of','objects'];
}]);
myApp.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    	$routeProvider.when('/', {
    		templateUrl: '/templates/index.html',
    		controller: 'ReportCardHomeController'
    	});
        $routeProvider.otherwise({
            templateUrl: '/',
            controller: 'ReportCardHomeController'
        });
    }
]);