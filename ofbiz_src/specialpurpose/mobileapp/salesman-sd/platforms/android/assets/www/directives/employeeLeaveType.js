/*global todomvc, angular */
'use strict';
/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('employeeLeaveType', ['$compile', '$rootScope','EmployeeService',
    function($compile, $rootScope, EmployeeService) {
        function init(scope, element, attrs) {
            scope.types = [];
           if($rootScope.network.status){
           		EmployeeService.getType().then(function(res) {
                scope.types = res.leaveType;
                if (scope.types && scope.types.length !== 0) {
                    scope.selected = scope.types[0].leaveTypeId;
                }
            });
           }else {
           		scope.types = $.parseJSON(localStorage.getItem('types'));
           		if (scope.types && scope.types.length !== 0) {
                    scope.selected = scope.types[0].leaveTypeId;
                }
           } 
            
            scope.changeCategory = scope.$parent.changeCategory;
            scope.$parent.getCategoryId = function() {
                return scope.selected;
            };
        }

        return {
            restrict: 'ACE',
            template: "<select ng-change='changeCategory()' ng-model='selected' class='col-lg-12 col-md-12 col-sm-12 col-xs-12'>"
                    + "<option ng-repeat='type in types' value='{{type.leaveTypeId}}'>{{type.description}}</option>"
                    + "</select>",
            scope: {
                selected : "="
            },
            link: init
        };
    }]);
