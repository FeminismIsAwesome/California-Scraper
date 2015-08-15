//= require angular/report-card.js
app.directive('legislatorNameSearchbar',function(LegislatorDataService) {
  return {
    transclude: true,
    templateUrl: '/templates/legislator_search.html',
    scope: {
      selectedLegislator: '='
    },
    link: function(scope,elem, attrs) {
      LegislatorDataService.getLegislators().then(function(legislators) {
        scope.legislators = legislators.data.map(function(legislator) {
            legislator.fullName = legislator.first_name + " " + legislator.last_name;
            return legislator;
        }).sort(function(legislator1, legislator2) {
          return legislator1.fullName.localeCompare(legislator2.fullName);
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
        	return legislator.fullName.includes(scope.legislatorSearch);
    		});
  		}
  	}

  }
});