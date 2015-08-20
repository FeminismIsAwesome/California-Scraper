var app = angular.module('reportcard');
app.filter('formatParty', function() {
	return function(party) {
		return party[0];
	}
});