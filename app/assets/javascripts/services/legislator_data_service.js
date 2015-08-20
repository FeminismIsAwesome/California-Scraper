var app = angular.module('reportcard');
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
        },
        getBillsForAllLegislators: function(bills) {
           return $http({
                url: '/api/legislators/votes/all',
                method: 'GET',
                params: {
                    "bills[]": bills.map(function(bill) {
                        return bill.billType + " " + bill.billNumber;
                    })
                }
            });  
        }
    }
}]);