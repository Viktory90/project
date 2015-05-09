/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ProductController', function($rootScope, $scope, $controller, ProductService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.categoryId = '';
	$scope.dataProducts = [];
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader('ProductList', "/main", false);
		ProductService.getTable().then(function(res) {
			$scope.tblConfig = res;
		});
	});
	$scope.$watch('categoryId', function() {
		if ($scope.categoryId && $scope.categoryId !== "") {
			if(localStorage.getItem('listProducts')){
				var data = $.parseJSON(localStorage.getItem('listProducts'));
				var arr = Array();
				for(var key in data){
					if($scope.categoryId == data[key]['productCategoryId']){
						arr.push(data[key]);
					}
				}
				$scope.dataProducts = arr;
				arr = new Array();
			}	
		}
	});
	$scope.changeCategory = function() {

	};
});
