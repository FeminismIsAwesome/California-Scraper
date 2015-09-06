console.log('doo daa doo daa');
var app = angular.module('reportcard');
var reproJusticeBillFeelings = {
  "AB241": {
    "ayes": 1
  },
  "AB1516": {
    "ayes": 1
  },
  "AB1522": {
    "ayes": 1
  },
  "AB1579": {
    "ayes": 1
  },
  "AB1266": {
    "ayes": 1
  },
  "AB4": {
    "ayes": 1
  },
  "AB60": {
    "ayes": 1
  },
  "AB154": {
    "ayes": 1
  },
  "SB138": {
    "ayes": 1
  },
  "SB1053": {
    "ayes": 1
  },
  "SB1094": {
    "ayes": 1
  },
  "SB1135": {
    "ayes": 1
  }
}


var reproJusticeBills = [{
  billType: "AB",
  billNumber: "241"
}, {
  billType: "AB",
  billNumber: "1516"
}, {
  billType: "AB",
  billNumber: "1522"
}, {
  billType: "AB",
  billNumber: "1579"
}, {
  billType: "AB",
  billNumber: "1266"
}, {
  billType: "AB",
  billNumber: "4"
}, {
  billType: "AB",
  billNumber: "60"
}, {
  billType: "AB",
  billNumber: "154"
}, {
  billType: "SB",
  billNumber: "138"
}, {
  billType: "SB",
  billNumber: "1053"
}, {
  billType: "SB",
  billNumber: "1094"
}, {
  billType: "SB",
  billNumber: "1135"
}];
app.service('BillService', ['$http', function($http) {
  var state = {};
  return {
    getBillsForCard: function() {
      return reproJusticeBills;
    },
    getBillOpinionsForCard: function() {
      return reproJusticeBillFeelings;
    },
    setBills: function(bills) {
      state.bills = bills;
    },
    getBills: function() {
      if(state.bills) {
        return state.bills;
      } 
      else {
        return reproJusticeBills;
      }
    }
  }
}]);