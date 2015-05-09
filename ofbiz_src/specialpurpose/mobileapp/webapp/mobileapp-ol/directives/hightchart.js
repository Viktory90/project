/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('chartui', ['$compile',
function($compile) {
	function init(scope, element, attrs) {
		var jqueryElm = $(element[0]);
		scope.$watch("config", function(){
			if(scope.config){
				$(jqueryElm).highcharts(scope.config);	
			}
		});
	}

	return {
		restrict : 'E',
		template : "<div class='chartui'></div>",
		scope : {
			config : '='
		},
		transclude : true,
		link : init
	};
}]);
