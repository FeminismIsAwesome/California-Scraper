
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