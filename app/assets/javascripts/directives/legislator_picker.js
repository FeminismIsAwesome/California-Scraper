app = angular.module('reportcard');
console.log("No legislator picker loads first");
app.directive('legislatorNameSearchbar', ['LegislatorDataService', function(LegislatorDataService) {
  return {
    transclude: true,
    templateUrl: '/templates/legislator_search.html',
    scope: {
      selectedLegislator: '=',
      searchAttribute: '@'
    },
    link: function(scope, elem, attrs) {
      LegislatorDataService.getLegislators().then(function(legislators) {
        scope.legislators = legislators.data.map(function(legislator) {
          legislator.name = legislator.first_name + " " + legislator.last_name;
          return legislator;
        }).sort(function(legislator1, legislator2) {
          return legislator1.name.localeCompare(legislator2.name);
        });
        scope.legislatorsToSearch = scope.legislators;
      });
      scope.selectLegislator = function($index) {
        scope.selectedLegislatorIndex = $index;
        scope.selectedLegislator = scope.legislatorsToSearch[$index];
      }
      scope.shouldHighlight = function($index) {
        return scope.selectedLegislatorIndex === $index;
      }
      scope.searchForLegislators = function() {
        scope.legislatorsToSearch = scope.legislators.filter(function(legislator) {
          return legislator[scope.searchAttribute].includes(scope.legislatorSearch);
        });
      }
    }

  }
}]);