app = angular.module('reportcard');
app.directive('formatVote', [function() {
  return {
    transclude: true,
    templateUrl: '/templates/directives/formatted_vote.html',
    scope: {
      vote: '='
    },
    link: function(scope, elem, attrs) {}
  }
}]);