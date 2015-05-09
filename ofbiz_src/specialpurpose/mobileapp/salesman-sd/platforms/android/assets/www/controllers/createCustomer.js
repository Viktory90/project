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
		$scope.setHeader('CreateCustomer', "/customer", false);
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
		sex : $scope.sex[0].value,
		startDate : ""
	};
	$scope.isChange = false;

	$scope.highlight = ["groupName", "address1", "city", "roadId"];
	$scope.$on('$viewContentLoaded', function() {
		$scope.getStore();
		$scope.initRoad();
		$('#content').bind('touchstart',function(){
			snapper.disable();
		});
		$('#content').bind('touchend',function(){
			snapper.enable();
		});
		$('#content').bind('touchcancel',function(){
			snapper.enable();
		});
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
		if ($scope.isChange) {
			if ($scope.validate()) {
				var point = $scope.getMarkerPoint();
				$scope.customer.latitude = point.latitude;
				$scope.customer.longitude = point.longitude;
				$scope.customer.startDate = formatDateYMD($scope.customer.startDate);
				$scope.customer.birthDay  = formatDateYMD($scope.customer.birthDay);
				if($rootScope.network.status){
					CustomerService.createCustomer($rootScope.showLoading, $scope.customer).then(function(data) {
						if (data.result) {
							bootbox.alert($rootScope.Map.CreateCustomerSuccess[$rootScope.key]);
							$scope.isChange = false;
							$('#createCustomer').trigger('reset');
						} else {
							bootbox.alert($rootScope.Map.CreateCustomerError[$rootScope.key]);
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
			bootbox.alert($rootScope.Map.ContentNotChange[key]);
		}
	};
	$scope.insertCustomerOffline = function(fields,input){
		SqlService.insert('customer',fields,input).then(function(res){
			bootbox.alert($rootScope.Map.CreateCustomersOfflineSuccess[$rootScope.key]);
			$('#createCustomer').trigger('reset');
			setTimeout(function(){
				bootbox.hideAll();
			},4000);
		},function(err){
			bootbox.alert($rootScope.Map.CreateCustomersOfflineError[$rootScope.key]);
			setTimeout(function(){
				bootbox.hideAll();
			},4000);
		});
	};
	/* validate form when submmit */
	$scope.validate = function() {
		var i = 0;
		for (var x in $scope.highlight) {
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
