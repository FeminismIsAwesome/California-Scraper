var app = angular.module('reportcard');
function parseLegislators(res) {
    return res.data.map(function(legislator) {
      legislator.name = legislator.first_name + " " + legislator.last_name;
      return legislator;
    });
}
app.service('LegislatorDataService', ['$http', function($http) {
    return {
        getLegislators: function() {
            return $http.get('/api/legislators').then(parseLegislators);
        },
        getLegislatorsForZipCode: function(zipCode) {
            return $http({
                url: '/api/legislators/zip_code',
                method: 'GET',
                params: {
                    zip_code: zipCode
                }
            }).then(parseLegislators);
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