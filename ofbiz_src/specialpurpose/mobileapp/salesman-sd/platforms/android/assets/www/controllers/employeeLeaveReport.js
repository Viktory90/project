/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('EmployeeLeaveReportController', function($rootScope, $scope,
		$controller, $location, EmployeeService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.tblConfig = {
		colName : [ 'Kiểu nghỉ phép', 'Lý do', 'Từ ngày', 'Đến ngày',
				'Trạng thái' ],
		colModel : [ {
			name : 'leaveTypeId',
			index : 'leaveTypeId',
			width : 25,
			sorttype : "string",
			editable : true
		}, {
			name : 'emplLeaveReasonTypeId',
			index : 'emplLeaveReasonTypeId',
			width : 17,
			sorttype : "string",
			editable : true
		}, {
			name : 'from',
			index : 'from',
			width : 17.5,
			sorttype : "string",
			editable : true
		}, {
			name : 'to',
			index : 'to',
			width : 17.5,
			sorttype : "string",
			editable : true
		}, {
			name : 'leaveStatus',
			index : 'leaveStatus',
			width : 23,
			sorttype : "string",
			editable : true
		} ]
	};
	$scope.data = {
		content : Array(),
		total : ''
	};
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("HistoryLeave", "/employee-leave", false);
		EmployeeService.getHistory($rootScope.showLoading).then(
				function(res) {
					for ( var x in res.completeList) {
						res.completeList[x].from = $scope
								.dateFormat(res.completeList[x].fromDate);
						res.completeList[x].to = $scope
								.dateFormat(res.completeList[x].thruDate);
					}
					$scope.data.content = res.completeList;
					$scope.data.total = res.resultsSizeAfterPartialList;
					$rootScope.hideLoading();
				}, function(){
					$rootScope.hideLoading();
				});
	});
	$scope.dateFormat = function(obj) {
		return obj.date + "-" + (obj.month + 1) + "-" + (obj.year + 1900);
	};
	$scope.back = function() {
		$location.path('employee-leave');
	};
});
