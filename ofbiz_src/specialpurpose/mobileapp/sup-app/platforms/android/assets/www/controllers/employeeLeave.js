/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('EmployeeLeaveController', function($rootScope, $scope,
		$controller, $location, EmployeeService ,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.setHeader('ForLeave', "/main", false);
	$scope.from = "";
	$scope.to = "";
	$scope.employee = {
		partyId : null,
		type : "",
		reason : "",
		from : "",
		to : "",
		note : ""
	};
	$scope.notification = "";
	$scope.mindate = "";
	$scope.condDate = {};
	$scope.$watch('from',function(){
		$scope.condDate.minFrom = formatDateYMD($scope.from);
	});
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
		if($rootScope.network.status){
			EmployeeService.submit($scope.employee, $rootScope.showLoading)
					.then(function(data) {
						$rootScope.hideLoading();
						if (data.retMsg && data.retMsg == "success") {
							$rootScope.openDialog($rootScope.Map.SendSuccess[$rootScope.key]);
						} else if (data.retMsg == "dupplicate") {
							$rootScope.openDialog($rootScope.Map.Dupplicate[$rootScope.key]);
						} else {
							$rootScope.openDialog($rootScope.Map.SendError[$rootScope.key]);
						}
					}, function() {
						$rootScope.hideLoading();
						$scope.showNotification(false,$rootScope.Map.SendError[key]);
						$scope.addToStack($scope.employee, "leaves");
					});
		}else {
			//create leave offline
			var fields = ["type","reason","fromDate","thruDate","note"];
			var input = [];
			var value =  [$scope.employee.type,$scope.employee.reason,$scope.employee.from,$scope.employee.to,$scope.employee.note];
			input.push(value);
			SqlService.insert('ForLeave',fields,input).then(function(data){
				console.log('create leave offline succes');
				if(data){
					$rootScope.openDialog($rootScope.Map.SendSuccess[$rootScope.key]);
				}
			},function(err){
				$rootScope.openDialog($rootScope.Map.SendError[$rootScope.key]);
			});
		}	
			
		}else $scope.showNotification(false,$rootScope.Map.PleasePressFullInformation[$rootScope.key]);
	};

});
