var app = angular.module('reportcard');
app.controller('ReportCardNewController', ['$scope', 'BillService', '$location', function($scope, BillService, $location) {
	$scope.bills = [];
	$scope.addBill = function() {
		bill = {
			billNumber: $scope.billNumber,
			billType: $scope.billType
		};
		$scope.bills.push(bill);
		$scope.billNumber = "";
		$scope.billType = "";
	}
	$scope.removeBill = function($index) {
		$scope.bills.splice($index, $index+1);
	}
	$scope.submitBills = function() {
		BillService.setBills($scope.bills);
		$location.path('/reportCard/yourcard/all');
	}
}]);