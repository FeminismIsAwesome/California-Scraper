var app = angular.module('reportcard');
app.filter('formatVote', function() {
	return function(vote) {
		if(vote.notAccountedFor) {
			return "-";
		}
		else if(vote.vote === "ayes") {
			return "yes";
		}
		else if(vote.vote === "noes") {
			return "no";
		} else {
			return "abs";
		}
	}
});