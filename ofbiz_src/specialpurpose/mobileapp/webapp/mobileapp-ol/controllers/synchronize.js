/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('SynchronizeController', function($rootScope, $scope,
		$controller, CustomerService, InventoryService, OrderService,
		EmployeeService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.hide = false;
	$scope.total = 0;
	$scope.current = 0;
	$scope.notification = "";
	$scope.roundProgressData = {
		label : 0,
		percentage : 0
	};
	$scope.$on("$viewContentLoaded", function() {
		$scope.setHeader("Đồng bộ hóa", "/main", false);
	});
	$scope.$watch('roundProgressData', function(newValue) {
		newValue.percentage = newValue.label / 100;
	}, true);
	$scope.synchronize = function() {
		var ordStr = localStorage.getItem("orders");
		var invStr = localStorage.getItem("inventories");
		var levStr = localStorage.getItem("leaves");
		var cusStr = localStorage.getItem("customers");
		if (ordStr || invStr || levStr || cusStr) {
			$scope.hide = true;
		} else {
			$scope.showNotification(false, "Không có dữ liệu đồng bộ");
		}
		if (ordStr) {
			var ordDa = JSON.parse(ordStr);
			$scope.total += ordDa.length;
			$scope.synOrder(ordDa);
		}
		if (invStr) {
			var invDa = JSON.parse(invStr);
			$scope.total += invDa.length;
			$scope.synInventory(invDa);
		}
		if (levStr) {
			var levDa = JSON.parse(levStr);
			$scope.total += levDa.length;
			$scope.synLeave(levDa);
		}
		if (cusStr) {
			var cusDa = JSON.parse(cusStr);
			$scope.total += cusDa.length;
			$scope.synCustomer(cusDa);
		}
	};
	$scope.synCustomer = function(data) {
		for (var x = 0; x < data.length; x++) {
			var customer = data[x];
			CustomerService.createCustomer(function() {
			}, customer).then(function(data) {
				$scope.calculatePercentage();
			});
		}
		localStorage.removeItem("customers");
	};
	$scope.synOrder = function(data) {
		for (var x = 0; x < data.length; x++) {
			var obj = data[x];
			var customer = obj.customer;
			var products = obj.products;
			OrderService.submitOrder(customer, products, null).then(
					function(data) {
						$scope.calculatePercentage();
					});
		}
		localStorage.removeItem("orders");
	}
	$scope.synInventory = function(data) {
		for (var x = 0; x < data.length; x++) {
			var obj = data[x];
			var products = obj.products;
			var customer = obj.customer;
			InventoryService.check(products, customer, null).then(
					function(data) {
						$scope.calculatePercentage();
					});

		}
		localStorage.removeItem("inventories");
	}
	$scope.synLeave = function(data) {
		for (var x = 0; x < data.length; x++) {
			var employee = data[x];
			EmployeeService.submit(employee, null).then(
					function(data) {
						if (data._EVENT_MESSAGE_
								&& data._EVENT_MESSAGE_
										.indexOf("Create successfully!") > -1) {
							$scope.calculatePercentage();
						}
					});
		}
		localStorage.removeItem("leaves");
	}
	$scope.calculatePercentage = function() {
		$scope.current++;
		var percent = $scope.current / $scope.total * 100;
		$scope.roundProgressData.label = $scope.current;
		$scope.$apply();
	}
});
