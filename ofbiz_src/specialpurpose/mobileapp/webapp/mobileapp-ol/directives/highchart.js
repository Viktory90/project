'use-strict';

olbius.directive('highchartui', [ '$compile', function($compile) {
	function init(scope, element, attrs) {

		var jqueryElm = $(element[0]);
		scope.highchart = $(jqueryElm);
		scope.$watch('config.series', function() {
			scope.highchart.highcharts(scope.config);
		});
		scope.$parent.redraw = function(series){
			if(scope.config){
				scope.sconfig.series = series;
				scope.highchart.highcharts(scope.config);
			}
		};
	}
	return {
		restrict : 'E',
		scope : {
			'config' : "="
		},
		template : "<div class='highchartui'></div>",
		transclude : true,
		link : init
	}
} ]);