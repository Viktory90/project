/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */

olbius.controller('CreateCustomerController', ["$rootScope", "$scope", "$controller", "$location", "CustomerService","SqlService",
function($rootScope, $scope, $controller, $location, CustomerService ,SqlService) {
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
		mobile : "",
		birthDay : "",
		sex : "",
		startDate : "",
	};
	$scope.isChange = false;

	$scope.highlight = ["groupName", "address1", "city", "roadId"];
	$scope.$on('$viewContentLoaded', function() {
		$scope.getStore();
		$scope.initRoad();
		console.log('sex',$scope.sex);
	});
	$scope.initRoad = function() {
		if ($scope.customers && $scope.customers.road && $scope.customers.road.length) {
			$scope.customer.roadId = $scope.customers.road[0].roadId;
		}
	};
	
	$scope.back = function() {
		$location.path('/customer');
	};
	$scope.$watch("customer", function() {
		$scope.isChange = true;
	});
	$scope.createCustomer = function() {
		console.log('infoCustomer' + JSON.stringify($scope.customer));
		if ($scope.isChange) {
			if ($scope.validate()) {
				var point = $scope.getMarkerPoint();
				console.log('point position' + JSON.stringify(point));
				$scope.customer.latitude = point.latitude;
				$scope.customer.longitude = point.longitude;
				$scope.customer.startDate = formatDateYMD($scope.customer.startDate);
				$scope.customer.birthDay  = formatDateYMD($scope.customer.birthDay);
				if($rootScope.network.status){
					CustomerService.createCustomer($rootScope.showLoading, $scope.customer).then(function(data) {
						if (data.result) {
							bootbox.alert("Tạo thành công");
							$scope.isChange = false;
							$('#createCustomer').trigger('reset');
						} else {
							bootbox.alert("Tạo lỗi");
						}
						$rootScope.hideLoading();
					}, function() {
						$scope.addToStack($scope.customer, "customers");
						$rootScope.hideLoading();
					});
				}else {
					var fields = ["groupName","city","roadId","latitude","longitude","mobile","birthDay","sex","startDate","address1"];
					var tmp = [];
					tmp = [$scope.customer.groupName , $scope.customer.city ,$scope.customer.roadId,$scope.customer.latitude , $scope.customer.longitude,$scope.customer.mobile,$scope.customer.birthDay,$scope.customer.sex,$scope.customer.startDate, $scope.customer.address1];
					var input = Array();
					if(tmp && tmp.length > 0 ){
						input.push(tmp);
					}
					if(input && input.length > 0){
						$scope.insertCustomerOffline(fields,input);
					};
				}
			}
		} else {
			bootbox.alert("Bạn chưa thay đổi nội dung");
		}
	};
	$scope.insertCustomerOffline = function(fields,input){
		SqlService.insert('customer',fields,input).then(function(res){
			bootbox.alert('Tạo khách hàng offline thành công');
			$('#createCustomer').trigger('reset');
			setTimeout(function(){
				bootbox.hideAll();
			},4000);
			log('create customer success');
		},function(err){
			bootbox.alert('Tạo khách hàng offline không thành công');
			setTimeout(function(){
				bootbox.hideAll();
			},4000);
			log('create customer error');
		});
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
