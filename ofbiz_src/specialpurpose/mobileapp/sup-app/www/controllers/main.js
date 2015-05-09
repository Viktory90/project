/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('MainController', function($rootScope, $scope, $controller, $location, AuthService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$rootScope.isHeader = true;
	$rootScope.isMain = true;
	$scope.buttons = [{
		link : 'inventory',
		content : 'Kiểm tra hàng tồn',
		icon : 'fa-check',
		class : 'btn-inventory'
	}, {
		link : 'order/false',
		content : 'Đơn hàng',
		icon : 'fa-list-alt',
		class : 'btn-order'
	}, {
		link : 'order/create',
		content : 'Tạo đơn hàng',
		icon : 'fa-shopping-cart',
		class : 'btn-create-order'
	}, {
		link : 'product',
		content : 'Sản phẩm',
		icon : 'fa-suitcase',
		class : 'btn-product'
	}, {
		link : 'customer',
		content : 'Khách hàng',
		icon : 'fa-user',
		class : 'btn-customer'
	}, {
		link : 'location',
		content : 'Bản đồ',
		icon : 'fa-map-marker',
		class : 'btn-calendar'
	}, {
		link : 'sale',
		content : 'Chương trình khuyến mại',
		icon : 'fa-tag',
		class : 'btn-promotion'
	}, {
		link : 'portal',
		content : 'Cổng thông tin',
		icon : 'fa-info-circle',
		class : 'btn-portal'
	}, {
		link : 'customer-opinion',
		content : 'Gửi thông tin',
		icon : 'fa-envelope',
		class : 'btn-sendinfo'
	}, {
		link : 'dashboard',
		content : 'DashBoard',
		icon : 'fa-dashboard',
		class : 'btn-dashboard'
	}, {
		link : 'sync',
		content : 'Đồng bộ',
		icon : 'fa-refresh',
		class : 'btn-sync'
	}, {
		link : 'employee-leave',
		content : 'Xin nghỉ phép',
		icon : 'fa-download',
		class : 'btn-nppinfo'
	}];
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Màn hình chính", "/main", true);
		//renderAction();
	});
	$scope.changeState = function(state) {
		// console.log(state);
		$location.path(state);
	};
});
