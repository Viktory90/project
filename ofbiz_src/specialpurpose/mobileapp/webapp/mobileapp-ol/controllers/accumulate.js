/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('AccumulateController', function($rootScope,$route, $scope, $controller, ProductService, CustomerService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.customers = {
		partyId : "",
	};
	$scope.check = true;
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Chương trình tích lũy", "/sale", false);
		$scope.inIt();
	});
	$scope.$watch('customers.partyId', function() {
		if ($scope.customers.partyId) {
			$scope.check = false;
			$scope.getAccumulateStore();
		} else
			$scope.check = true;
	});
	$scope.index = {};
	$scope.$watch('listAccumulate.productPromoId', function() {
		for (var x in $scope.listAccumulate.content) {
			if ($scope.listAccumulate.productPromoId == $scope.listAccumulate.content[x].productPromoId) {
				$scope.index = $scope.listAccumulate.content[x];
				$scope.index.customerId = $scope.customers.partyId;
			}
		}
	});
	$scope.cancel = function(){
		$route.reload();
	};
	$scope.inIt = function() {
		$scope.getAllStore();
	};
	$scope.listAccumulate = {
		productPromoId : "",
		content : ""
	};
	$scope.getAccumulateStore = function() {
		var currentCustomer = $.parseJSON(localStorage.getItem("currentCustomer"));
		ProductService.getAccumulateStore($scope.customers.partyId).then(function(data) {
			$scope.listAccumulate.content = data.listAccumulate;
		});
	};
	$scope.getAllStore = function() {
		CustomerService.getAll(0, 100, null).then(function(data) {
			$scope.customers = data.customers;
		});
	};
	$scope.accumulateRegister = function() {
		if ($scope.index) {
			ProductService.accumulateRegister($scope.index).then(function(data) {
				console.log(data);
				if (data.accumulate) {
					bootbox.alert("Đăng ký chương trình tích lũy thành công");
					$('#accRegister').trigger('reset');
				} else
					bootbox.alert("Đăng ký chương trình tích lũy không thành công");
			});
		}
	};
});
