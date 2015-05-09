/*global todomvc, angular */
'use strict';
/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('employeeLeaveReason', ['$compile','$rootScope','EmployeeService',
    function($compile,$rootScope ,EmployeeService) {
        function init(scope, element, attrs) {
            scope.selected = 0;
            scope.reasons = [];
            if($rootScope.network.status){
            	EmployeeService.getReason().then(function(res) {
	                scope.reasons = res.leaveTypeReason;
	                if (scope.reasons && scope.reasons.length !== 0) {
	                    scope.selected = scope.reasons[0].emplLeaveReasonTypeId;
	                }
           		 });
            }else {
            	scope.reasons = $.parseJSON(localStorage.getItem('reasons'));
            	 if (scope.reasons && scope.reasons.length !== 0) {
	                    scope.selected = scope.reasons[0].emplLeaveReasonTypeId;
	                }
            }
            scope.changeCategory = scope.$parent.changeCategory;
            scope.$parent.getCategoryId = function() {
                return scope.selected;
            };
        }

        return {
            restrict: 'ACE',
            template: "<select ng-change='changeCategory()' ng-model='selected' class='col-lg-12 col-md-12 col col-sm-12 col-xs-12'>"
                    + "<option ng-repeat='reason in reasons' value='{{reason.emplLeaveReasonTypeId}}'>{{reason.emplLeaveReasonTypeId}}</option>"
                    + "</select>",
            scope: {
                selected : "="
            },
            link: init
        };
    }]);
