/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('EmployeeLeaveController', function($rootScope, $scope,
		$controller, $location, EmployeeService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.setHeader("Xin nghỉ phép", "/main", false);
	$scope.from = "";
	$scope.to = "";
	$scope.employee = {
		type : "",
		reason : "",
		from : "",
		to : "",
		note : ""
	};
	$scope.notification = "";
	$scope.mindate = "";
	$scope.$on('$viewContentLoaded', function() {
		$scope.mindate = getCurrentDateYMD();
	});

	$scope.viewReport = function() {
		$location.path('/employee-leave/report');
	};
	$scope.submit = function() {
		if ($scope.from && $scope.to) {
			$scope.employee.to = formatDateDMY($scope.to);
			$scope.employee.from = formatDateDMY($scope.from);
			EmployeeService.submit($scope.employee, $rootScope.showLoading)
					.then(function(data) {
						$rootScope.hideLoading();
						console.log(data);
						if (data.retMsg && data.retMsg == "success") {
							$scope.showNotification(true, "Gửi thành công");
						} else if (data.retMsg == "dupplicate") {
							$scope.showNotification(false, "Bạn đã gửi đơn");
						} else {
							$scope.showNotification(false, "Gửi đơn lỗi");
						}
					}, function() {
						$rootScope.hideLoading();
						$scope.showNotification(false, "Gửi đơn lỗi");
						$scope.addToStack($scope.employee, "leaves");
					});
		}
	};

});
