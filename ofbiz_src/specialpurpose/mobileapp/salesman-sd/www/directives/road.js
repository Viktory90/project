/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('road', ['$compile', 'LoadRoadService',
    function($compile, LoadRoadService) {
        function init(scope, element, attrs) {
            scope.roads = [];
            LoadRoadService.getRoad().then(function(data) {
                scope.roads = data.roads;
                if (data.roads && data.roads.length !== 0) {
                    scope.roadid = data.roads[0].roadId;
                }
            });
//            scope.$watch('roadid', function() {
//                scope.$parent.roadid = scope.roadid;
//            });
        }

        return {
            restrict: 'ACE',
            template: "<select ng-model='roadid'"
                    + "ng-options='ct.roadId as ct.name for ct in roads' class='col-lg-6 col-md-8 col-sm-6 col-xs-12'>"
                    + "</select>",
            scope: {
                roadid: '='
            },
            link: init
        };
    }
]);
