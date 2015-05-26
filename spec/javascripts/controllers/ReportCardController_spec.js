describe("RecipesController", function() {
	beforeEach(module('reportcard'));
	controller = undefined;
	scope = {};
	beforeEach(inject(function($rootScope, $controller) {
		scope = $rootScope.$new();
		controller = $controller('ReportCardHomeController', {$scope: scope});
	}));
	it("should run a test for me", function() {
		expect(2).toBe(2);
		expect(scope.greeting).toBe("Hola! This is Report Card Builder v0.1");
	});
});