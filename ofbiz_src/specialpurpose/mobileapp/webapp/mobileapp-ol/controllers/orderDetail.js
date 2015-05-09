/*
 * controller for detail order screen
 */
olbius.controller('OrderDetailController', function($rootScope, $scope, $controller, $routeParams, $window, $location, OrderService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.id = $routeParams.id;
	$scope.orderHeader = {};
	$scope.productStore = {};
	$scope.orderShipment = {};
	$scope.orderDetail = [];
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Chi tiết đơn hàng", "/order", false);
		OrderService.getOrderDetail(function() {
		}, $scope.id).then(function(res) {
			if (res.data !== "error") {
				$scope.orderHeader = res.orderHeader;
				$scope.productStore = res.productStore;
				$scope.orderShipment = res.orderShipment;
				$scope.orderDetail = res.orderDetail;
			}
		});
	});
	$scope.back = function() {
		$window.history.back();
	};

	/*copy current order to create a new order*/
	$scope.copy = function() {
		var data = Array();
		if (localStorage.currentCustomer) {
			var store = JSON.parse(localStorage.getItem("currentCustomer"));
			if ($scope.orderDetail.length) {
				for (var x in $scope.orderDetail) {
					var obj = {
						productId : $scope.orderDetail[x].productId,
						qtyInInventory : $scope.orderDetail[x].quantity
					};
					data.push(obj);
				}
				var key = "creatingorder_" + store.partyIdTo;
				localStorage.setItem(key, JSON.stringify(data));
			}
		}
		$location.path("order/create");
	};
	$scope.calculateTotalCost = function(data) {
		var total = 0;
		for (var x in data) {
			var obj = data[x];
			if (obj.quantity && obj.unitPrice) {
				total += obj.quantity * obj.unitPrice;
			}
		}
		return total;
	};
});
