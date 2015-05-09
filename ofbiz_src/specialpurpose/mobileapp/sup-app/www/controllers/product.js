/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ProductController', function($rootScope, $scope, $controller, ProductService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.categoryId = '';
	$scope.dataProducts = [];
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Danh sách sản phẩm", "/main", false);
		ProductService.getTable().then(function(res) {
			$scope.tblConfig = res;
		});
	});
	$scope.$watch('categoryId', function() {
		if ($scope.categoryId && $scope.categoryId !== "") {
			if ($scope.categoryId != "all") {
				var key = "products-" + $scope.categoryId;
				var products = $.parseJSON(localStorage.getItem(key));
				if (products) {
					$scope.dataProducts = products;
				} else {
					ProductService.getByCategory($scope.categoryId, 0, config.pageSize, $rootScope.showLoading).then(function(res) {
						$scope.dataProducts = res.listProduct;
						localStorage.setItem(key, JSON.stringify(res.listProduct));
						$rootScope.hideLoading();
					});
				}
			} else {
				var key = "products";
				var products = $.parseJSON(localStorage.getItem(key));
				if (products) {
					$scope.dataProducts = products;
				} else {
					ProductService.getAll($rootScope.showLoading).then(function(res) {
						if (res.listProduct) {
							$scope.dataProducts = res.listProduct;
							if ($scope.products.length) {
								localStorage.setItem("products", JSON.stringify(res.listProduct));
							}
						}
					}, function(res) {
						console.log("error" + JSON.stringify(res));
					});
				}
			}
		}
	});
	$scope.changeCategory = function() {

	};
});
