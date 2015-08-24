app = angular.module('reportcard');
app.directive('legislatorZipCodeSearchbar', ['LegislatorDataService', function(LegislatorDataService) {
  return {
    transclude: true,
    templateUrl: '/templates/directives/legislator_search_zipcode.html',
    scope: {
      selectedLegislator: '='
    },
    link: function(scope, elem, attrs) {
      LegislatorDataService.getLegislators().then(function(legislators) {
        scope.legislators = legislators.sort(function(legislator1, legislator2) {
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
      	LegislatorDataService.getLegislatorsForZipCode(scope.zipCodeSearch).then(function(	legislators) {
      		scope.legislatorsToSearch = legislators;
      		scope.selectedLegislator = "";
        });

      }
    }

  }
}]);