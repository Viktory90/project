/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('InventoryController', function($rootScope, $scope, $controller, $location, InventoryService, ProductService, GPS) {
	/* extends base controller */
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.currentStore = null;
	$scope.isValidDistance = false;
	$scope.isInventory = false;
	$scope.products = null;
	$scope.previousInventory = null;
	$scope.currentInventory = null;
	$scope.keyword = "";
	$scope.ads = {
		posm : "true",
		marketing : "true"
	};
	/* init function */
	var startTime  = {};
	var endTime = {};
	$scope.$on('$viewContentLoaded', function() {
		startTime  = new Date();
		$scope.setHeader("Kiểm tồn", "/store", false);
		if (!localStorage.customers) {
			$location.path("store");
		} else {
			$scope.currentStore = JSON.parse(localStorage.getItem("currentCustomer"));
		}
		$scope.getLastInventory();
		$scope.reloadDistance();
		$scope.initProduct();
	});
	/* check if keyword filter */
	$scope.$on("keyword", function(event, arg){
		$scope.keyword = arg.keyword;
	});
	 $scope.example = {
        value: 12
      };
	/* init product */
	$scope.initProduct = function() {
		var data = [];
		if (localStorage.products) {
			data = JSON.parse(localStorage.getItem("products"));
		} else {
			$scope.getAllProduct();
			if (localStorage.products) {
				data = JSON.parse(localStorage.getItem("products"));
			}
		}
		if (data) {
			for (var x in data) {
				data[x].quantity = 0;
			}
			$scope.products = data;
		}
	};
	
	$scope.getAllProduct = function() {
		ProductService.getAll(function() {
		}).then(function(res) {
			if (res.listProduct) {
				$scope.products = res.listProduct;
				localStorage.setItem("products", JSON.stringify(res.listProduct));
			}
		}, function(res) {
			console.log("error" + JSON.stringify(res));
		});
	};
	/* get latest check inventory of salesman */
	$scope.getLastInventory = function() {
		if ($scope.currentStore) {
			var key = "inventory_" + $scope.currentStore.partyIdTo;
			if (localStorage[key] && !localStorage.isCreatedOrder) {
				var data = JSON.parse(localStorage[key]);
				$scope.initInventoryDate(data);
			} else {
				InventoryService.getByCustomer($scope.currentStore.partyIdTo, $rootScope.showLoading).then(function(res) {
					$rootScope.hideLoading();
					if (res.inventoryCusInfo && res.inventoryCusInfo.length != 0) {
						var data = res.inventoryCusInfo;
						$scope.initInventoryDate(data);
						localStorage.setItem(key, JSON.stringify(res.inventoryCusInfo));
					} else {
						$scope.isInventory = true;
					}

				}, function(res) {
					console.log("inventory" + JSON.stringify(res));
					$rootScope.hideLoading();
				});
			}
		}
	};
	$scope.initInventoryDate = function(data) {
		var res = Array();
		for (var x in data) {
			var obj = {
				productId : data[x].productId,
				productName : data[x].productName,
				orderDate : data[x].orderDate,
				qtyInInventory : data[x].qtyInInventory,
				orderId : data[x].orderId,
				max : data[x].qtyInInventory
			};
			res.push(obj);
		}
		$scope.previousInventory = JSON.parse(JSON.stringify(res));
		$scope.currentInventory = res;
	};
	/*check current inventory < last inventory*/
	$scope.addProductToInventoryList = function(product) {
		var obj = {
			productId : product.productId,
			qtyInInventory : 0,
			productName : product.productName,
			expiryDate : ""
		};
		$scope.currentInventory.push(obj);
	};
	/*remove inventory product from list*/
	/*$scope.swipeToDelete = function(product) {
	 $scope.currentInventory.splice($scope.currentInventory.indexOf(product), 1);
	 };*/
	/*reload distance of salesman to store*/
	$scope.reloadDistance = function() {
		if ($scope.currentStore) {
			var point = {
				lat : $scope.currentStore.latitude,
				long : $scope.currentStore.longitude
			};
			GPS.checkDistance($scope, point);
		}
	};
	
	/* check inventory */
	$scope.checkInventory = function() {
		var inven = Array();
		var error = false;
		for (var x in $scope.currentInventory) {
			inven.push({
				productId : $scope.currentInventory[x].productId,
				productName : $scope.currentInventory[x].productName,
				orderId : $scope.currentInventory[x].orderId,
				qtyInInventory : $scope.currentInventory[x].qtyInInventory,
			});
		}
		if ($scope.currentStore) {
			InventoryService.check(inven, $scope.currentStore.partyIdTo, $rootScope.showLoading).then(function(data) {
				$scope.isInventory = true;
				$rootScope.hideLoading();
				if (data.retMsg == "update_success") {
					endTime = new Date();
					alert((endTime - startTime)/1000);
					var key = "inventory_" + $scope.currentStore.partyIdTo;
					localStorage.setItem(key, JSON.stringify($scope.currentInventory));
				} else {
					bootbox.alert("fucking error");
				}
			}, function() {
				$scope.isInventory = true;
				bootbox.alert("fucking error");
				var data = {
					product : products,
					customer : $scope.customer
				};
				$rootScope.hideLoading();
				$scope.addToStack(data, 'inventories');
			});
		}
	};
	$scope.isValueInventory = function() {
		if ($scope.currentStore) {
			var key = "inventory" + $scope.currentStore.partyIdTo;
			var current = localStorage.getItem(key);
			if (!current) {
				return true;
			} else if (JSON.stringify($scope.currentInventory) == current) {
				return false;
			}
			return true;
		} else {
			bootbox.alert("Thông tin khách hàng không đúng");
			return false;
		}

	};
	$scope.createOrder = function(action) {
		if (action && action == "copy" && $scope.currentStore) {
			var key = "creatingorder_" + $scope.currentStore.partyIdTo;
			var data = Array();
			if ($scope.currentInventory && $scope.previousInventory) {
				if ($scope.currentInventory.length < $scope.previousInventory.length) {
					data = $scope.calculateOrder($scope.currentInventory, $scope.previousInventory);
				} else {
					data = $scope.calculateOrder($scope.previousInventory, $scope.currentInventory);
				}
				if (data.length) {
					localStorage.setItem(key, JSON.stringify(data));
				}
			}
		}
		$location.path('/order/create');
	};
	$scope.calculateOrder = function(min, max) {
		var res = Array();
		var remain = 0;
		for (var x in max) {
			var obj = JSON.parse(JSON.stringify(max[x]));
			var old = $scope.findProduct(min, obj.productId);
			if (old) {
				remain = Math.abs(obj.qtyInInventory - old.qtyInInventory);
				obj.qtyInInventory = remain;
			}
			res.push(obj);
		}
		return res;
	};
	$scope.findProduct = function(data, key) {
		var res = _.where(data, {
			productId : key
		});
		if (res.length) {
			var obj = {};
			var total = 0;
			for (var x in res) {
				obj = res[x];
				total += res[x].qtyInInventory;
			}
			obj.qtyInInventory = total;
			return obj;
		}
	};
});

/*if (!$scope.currentInventory[x].qtyInInventory || !$scope.currentInventory[x].expiryDate) {
 if ($scope.currentInventory[x].expiryDate) {
 if (!$scope.currentInventory[x].quantity) {
 error = true;
 $("#quantity" + $scope.currentInventory[x].productId).addClass("error");
 } else {
 $("#quantity" + $scope.currentInventory[x].productId).removeClass("error");
 }
 } else if ($scope.currentInventory[x].qtyInInventory) {
 if (!$scope.currentInventory[x].expiryDate) {
 error = true;
 $("#date" + $scope.currentInventory[x].productId).addClass("error");
 } else {
 $("#date" + $scope.currentInventory[x].productId).removeClass("error");
 }
 }
 } else {
 var dt = formatDateDMY($scope.currentInventory[x].expiryDate);
 inven.push({
 productId : $scope.currentInventory[x].productId,
 qtyInInventory : $scope.currentInventory[x].qtyInInventory,
 expireDate : dt
 });
 }*/