/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('StoreController', function($rootScope, $scope, $controller, $location, $compile, CustomerService, GPS) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.customers = {
		content : [],
		road : []
	};
	$scope.current = 1;
	$scope.total = 0;
	$scope.currentLocation = null;
	$scope.setHeader("Danh sách khách hàng", "/main", false);
	$scope.$on("$viewContentLoaded", function() {
		$scope.getStore();
		GPS.getCurrentLocation($scope, false);
//		initTable();
	});
	$scope.initCustomer = function() {
		var length = $scope.customers.content.length;
		if (length) {
			getPage($scope.customers.content, 1, 5);
			$scope.total = Math.ceil(length / 5);
			generatePagination();
			changePaginationStyle(1);
		}
	};
	$scope.$watch("customers.content", function() {
		$scope.initCustomer();
	});
	$scope.next = function() {
		if ($scope.current < $scope.total) {
			var tmp = $scope.current + 1;
			changePaginationStyle(tmp);
			$scope.current = tmp;
			getPage($scope.customers.content, $scope.current, 5);
		}
	};
	$scope.previous = function() {
		if ($scope.current > 1) {
			var tmp = $scope.current - 1;
			changePaginationStyle(tmp);
			$scope.current = tmp;
			getPage($scope.customers.content, $scope.current, 5);
		}
	};
	var generatePagination = function() {
		var str = "";
		if ($scope.total > 1) {
			var tmp = 0;
			for (var x = 0; x < $scope.total; x++) {
				tmp = parseInt(x + 1);
				str += "<button class='btn page-item' id='page-" + tmp + "' ng-click='pagination(" + tmp + ")'>" + tmp + "</button>";
			}
		}
		$("#paginationNumber").html(str);
		$compile($("#paginationNumber").contents())($scope);
	};
	$scope.pagination = function(page) {
		changePaginationStyle(page);
		$scope.current = page;
		getPage($scope.customers.content, $scope.current, 5);
	};
	var changePaginationStyle = function(page) {
		if (page != $scope.current) {
			$("#page-" + $scope.current).removeClass("page-active");
			$("#page-" + page).addClass("page-active");
		} else {
			$("#page-" + page).addClass("page-active");
		}
	};
	var getPage = function(data, page, pagesize) {
		var end = data.length;
		var start = (page - 1) * pagesize;
		var to = start + pagesize;
		var limit = end < to ? end : to;
		var str = "";
		// for (var x = start; x < limit; x++) {
		for (var x = 0; x < end; x++) {	
			var obj = data[x];
			str += "<div class='col-lg-12 col-md-12 col-xs-12 col-sm-12 store-row-container' ng-click='toStore(" + x + ")'>" + "<div class='store-row'><h3 class='store-row-header'>";
			str += obj.groupName;
			str += "</h3><div class='store-row-info'><i class='glyphicon glyphicon-map-marker'></i>&nbsp;<b>Địa chỉ:&nbsp;</b>";
			str += obj.address1;
			str += "&nbsp;";
			if (obj.city) {
				str += obj.city;
			}
			str += "</div><div class='store-row-info'>" + "<i class='glyphicon glyphicon-phone-alt'></i>&nbsp;<b>Điện thoại:&nbsp;</b>";
			if (obj.phone) {
				str += obj.phone;
			} else {
				str += 0;
			}
			str += "</div><div class='store-row-info'><i class='glyphicon glyphicon-road'></i>&nbsp;";
			if (obj.distance) {
				str += "<span><b>&nbsp;Khoảng cách:&nbsp;</b>";
				str += obj.distance.text;
				str += "</span>";
			}
			str += "</div></div></div>";
		}
		$("#listStore").html(str);
		$compile($("#listStore").contents())($scope);
	};
	/* watch current salesman's location change */
	$scope.$watch("currentLocation", function() {
		if ($scope.currentLocation) {
			$scope.reloadDistance();
		}
	});
	/*reload distance to current salesman'location*/
	$scope.reloadDistance = function() {
		var point = {};
		var distance = 0;
		var temp = [];
		for (var x in $scope.customers.content) {
			var data = $scope.customers.content[x];
			if (data.latitude && data.longitude) {
				point = {
					lat : data.latitude,
					long : data.longitude
				};
				distance = GPS.getDistance($scope.currentLocation, point);
				data.distance = {
					origin : distance,
					text : convertDistance(distance)
				};
				temp = $scope.sortDistance(data, temp);
			} else {
				data.distance = {
					origin : 1000000,
					text : "Không thể xác định"
				};
				temp.push(data);
			}
		}
		$scope.customers.content = temp;

	};
	/*sort list customer by distance*/
	$scope.sortDistance = function(obj, arr) {
		if (arr.length == 0) {
			arr.push(obj);
			return arr;
		} else {
			for (var x = 0; x < arr.length; x++) {
				if (arr[x].distance.origin > obj.distance.origin) {
					arr.splice(x, 0, obj);
					return arr;
				}
			}
		}
		arr.push(obj);
		return arr;
	};

	/*to inventory customer & create order screen*/
	$scope.toStore = function(id) {
		var customer = $scope.customers.content[id];
		localStorage.setItem("currentCustomer", JSON.stringify(customer));
		$location.path("inventory");
	};
	$scope.toMap = function() {
		$location.path("location");
	};
});
