/*global todomvc, angular */
'use strict';
/**
 * The order controller for the order & create order screen. The controller:
 * Retrieves and persists the model via the order service
 */

/* controller for orders screen */
olbius.controller('OrderController', function($rootScope, $routeParams, $scope, $controller, $location, $window, OrderService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.iscurrent = $.parseJSON($routeParams.iscurrent);
	$scope.listOrder = {
		test : '',
		content : Array(),
		total : 0,
		size : 0,
		debt : 0,
		debtAmount : 0,
		pay : 0,
		payAmount : 0,
	};
	$scope.timeViewOrder = [
		{
			text : 'Tuần này',
			value : 'thisweek'
		},
		{
			text : 'Tháng này',
			value : 'thismonth'
		}
	];
	$scope.val = $scope.timeViewOrder[0].value;
	$scope.loading = false;
	$scope.currentCustomer = null;
	$scope.currentPage = 0;
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Danh sách đơn hàng", "/main", false);
		$scope.init();
		$scope.scroll();
	});
	$scope.getListOrder = function(){
		// console.log($scope.val);
	};
	/*bind keyword changed*/
	$scope.$on("keyword", function(arg) {
		console.log(arg);
	});
	/*bind scroll*/
	
	$scope.scroll = function() {
		var obj = angular.element($window);
		var bottom = angular.element($("#bottom"));
		obj.bind("scroll", function(res) {
			if ((this.pageYOffset + $(window).height()) == $(document).height()) {
				$scope.loadMore();
			}
		});
	};
	$scope.listCustomer = {};
	/*init list Order*/
	$scope.init = function() {
		if(localStorage.getItem('customers')){
			$scope.listCustomer = $.parseJSON(localStorage.getItem('customers'));
		}
		if (localStorage.currentCustomer) {
			$scope.currentCustomer = JSON.parse(localStorage.getItem("currentCustomer"));
			var key = "listOrder";
			if ($scope.iscurrent) {
				key = "currentListOrder";
			}
			// if (localStorage.getItem(key) && $scope.iscurrent == $.parseJSON(localStorage.getItem("iscurrent"))) {
			if (localStorage.getItem(key)) {	
				var list = JSON.parse(localStorage.getItem(key));
				if (list && list.content.length) {
					$scope.listOrder = list;
					var length = list.content.length;
					$scope.currentPage = Math.ceil(length / config.pageSize);
				} else {
					$scope.loadMore(true);
				}
			} else {
				$scope.loadMore(true);
			}
			if ($scope.iscurrent) {
				localStorage.setItem("iscurrent", $scope.iscurrent);
			}
		}
	};
	/*get data from server*/
	$scope.getData = function(status) {
		if (!status) {
			var refresh = $rootScope.showLoading;
			var close = $rootScope.hideLoading;
		} else {
			var refresh = function() {
				$scope.loading = true;
				$("#refresh").addClass("rotate");
			};
			var close = function() {
				$scope.loading = false;
				$("#refresh").removeClass("rotate");
			};
		}
		$scope.getList(refresh, close);
	};
	$scope.getList = function(refresh, close) {
		var partyId = "";
		var key = "listOrder";
		if ($scope.iscurrent && $scope.currentCustomer) {
			partyId = $scope.currentCustomer.partyIdTo;
			key = "currentListOrder";
		}
		OrderService.getList(refresh, $scope.currentPage, config.pageSize).then(function(data) {
			console.log('data' + JSON.stringify(data));
			for (var x in data.orderHeaderList) {
				if (data.orderHeaderList[x].status) {
					data.orderHeaderList[x].status = "Đã thanh toán";
					$scope.listOrder.pay++;
					$scope.listOrder.payAmount += data.orderHeaderList[x].grandTotal;
				} else {
					data.orderHeaderList[x].status = "Chưa thanh toán";
					$scope.listOrder.debt++;
					$scope.listOrder.debtAmount += data.orderHeaderList[x].grandTotal;
				}
				$scope.listOrder.content.push(data.orderHeaderList[x]);
			}
			$scope.listOrder.total = data.total;
			//set number page
			$scope.listOrder.size = data.size;
			localStorage.setItem(key, JSON.stringify($scope.listOrder));
			close();
		}, function() {
			close();
		});
	};
	/*load more data when scroll to bottoms*/
	$scope.loadMore = function(init) {
		if ($scope.listOrder.total && $scope.listOrder.content.length) {
			if ($scope.currentPage < $scope.listOrder.total) {
				$scope.currentPage++;
				$scope.getData(true);
			}
		} else if (init) {
			$scope.getData();
		}

	};
	$scope.onSelectRow = function(id) {
		$location.path('order/detail/' + id);
		//$scope.$apply();
	};
});