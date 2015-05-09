/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */

olbius.controller('CreateCustomerController', ["$rootScope", "$scope", "$controller", "$location","CustomerService","Route",
function($rootScope, $scope, $controller, $location, CustomerService , Route) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.$on("$viewContentLoaded", function() {
		$scope.disableScrollX();
		$scope.setHeader("Tạo khách hàng", "/customer", false);
		
	});
	$scope.customers = {};
	$scope.intervalgetLocation = true;
	/* init customer information */
	$scope.sex = [
		{"value" : "F","text" : "Female"},
		{"value" : "M","text" : "Male"},
		{"value" : "#" ,"text" : "#"}
	];
	$scope.customer = {
		groupName : "",
		address1 : "",
		city : "",
		roadId : "",
		latitude : "",
		longitude : "",
		mobile : "" ,
		birthDay : "",
		sex : $scope.sex[0].value,
		startDate : "",
	};
	$scope.isChange = false;
	$scope.listRoad = {};
	$scope.highlight = ["groupName", "address1", "city", "roadId"];
	$scope.$on('$viewContentLoaded', function() {
		$scope.getStore();
		$scope.getListRoute();
	});
	
	$scope.getListRoute = function(){
		Route.getListRouteAndSalesMan().then(function(res){
			console.log(res);
			if(res.data.result.listRoute){
				$scope.listRoad = res.data.result.listRoute;
			};
		},function(err){
		});
	};	
	// $scope.initRoad = function() {
		// if ($scope.customers && $scope.customers.road && $scope.customers.road.length) {
			// $scope.customer.roadId = $scope.customers.road[0].roadId;
		// }
	// };
	
	$scope.back = function() {
		$location.path('/customer');
	};
	$scope.$watch("customer.roadId", function() {
		$scope.isChange = true;
		console.log($scope.customer.roadId);
	});
	$scope.isNumber = function(number){
		return !isNaN(parseFloat(number));
	};
	$scope.checkNumber = false;
	$scope.createCustomer = function() {
		if($scope.isNumber($scope.customer.mobile)){
			$scope.checkNumber  = true;
		}else {
			$scope.checkNumber = false;
		};
		if ($scope.isChange) {
			if ($scope.validate()) {
				var point = $scope.getMarkerPoint();
				var pointSelected = $scope.PointSelected;
				
				if(pointSelected){
					$scope.customer.latitude = pointSelected.lat;
					$scope.customer.longitude = pointSelected.long;
				}else{
					$scope.customer.latitude = point.latitude;
					$scope.customer.longitude = point.longitude;
				}
				$scope.customer.startDate = formatDateYMD($scope.customer.startDate);
				$scope.customer.birthDay  = formatDateYMD($scope.customer.birthDay);
				CustomerService.createCustomer($rootScope.showLoading, $scope.customer).then(function(data) {
					if (data.result) {
						bootbox.alert("Tạo thành công");
						$scope.isChange = false;
						$('#createCustomer').trigger('reset');
						console.log('trigger');
					} else {
						bootbox.alert("Tạo lỗi");
					}
					$rootScope.hideLoading();
				}, function() {
					$scope.addToStack($scope.customer, "customers");
					$rootScope.hideLoading();
				});
			}
		} else {
			bootbox.alert("Bạn chưa thay đổi nội dung");
		}
	};
	/* validate form when submmit */
	$scope.validate = function() {
		var i = 0;
		for (var x in $scope.highlight) {
//			console.log($scope.highlight[x]);
			if (!$scope.customer[$scope.highlight[x]]) {
				
				$("#c" + $scope.highlight[x]).addClass("error");
				i++;
			} else {
				$("#c" + $scope.highlight[x]).removeClass("error");
			}
		}
		if (i === 0) {
			return true;
		}
		return false;
	};
}]);
