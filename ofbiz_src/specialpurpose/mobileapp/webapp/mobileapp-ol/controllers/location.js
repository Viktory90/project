/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('LocationController', ["$rootScope", "$scope", "$controller", "$timeout" ,'uiGmapGoogleMapApi', 'geolocation', "LoadRoadService",
function($rootScope, $scope, $controller, $timeout, GoogleMapApi, geolocation, LoadRoadService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.roadid = '';
	$scope.marker = {
		id : 0,
		coords : {},
		options : {
			draggable : false
		}
	};
	$scope.customers = [];
<<<<<<< HEAD
	$scope.accessor = {
	};
||||||| merged common ancestors
=======

>>>>>>> 0a0f8ec86f1e460403dec0eae8cdacf2264fa1af
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Bản đồ", "/main", false);
		$scope.disableScrollX();
		$scope.disableScrollY();
		$scope.height = 860;
		$scope.getStore();
<<<<<<< HEAD
		//$scope.initRoad();
	});
	$scope.$watch("accessor", function(){
		console.log($scope.accessor);
	});
	$scope.$watch('roadid', function() {
		if ($scope.roadid && $scope.roadid !== '') {

||||||| merged common ancestors
		//$scope.initRoad();
	});

	$scope.$watch('roadid', function() {
		if ($scope.roadid && $scope.roadid !== '') {

=======
		if(localStorage.getItem('customers')){
			$scope.customers = JSON.parse(localStorage.getItem('customers')).content;
>>>>>>> 0a0f8ec86f1e460403dec0eae8cdacf2264fa1af
		}
		$('#content').bind('click',function(){
			console.log(11);
			snapper.disable();
		});
	});
	
	$scope.initRoad = function() {
		if ($scope.customers && $scope.customers.road && $scope.customers.road.length) {
			$scope.customer.roadId = $scope.customers.road[0].roadId;
		}
	};
	$scope.data = [];
	$scope.$watch("customers", function() {
		for (var x in $scope.customers) {
			var temp = $scope.customers[x];
			if (temp.latitude && temp.longitude) {
				var obj = {
					id : x,
					icon : 'assets/images/blue_marker.png',
					latitude : temp.latitude,
					longitude : temp.longitude,
					showWindow : true,
					title : temp.groupName + " - " + temp.address1
				};
				$scope.data.push(obj);
			}
		}
		$timeout(function(){
			$scope.setMarkers($scope.data);
		}, 100);
	});
	$scope.setToMarkers = function(){
		
	};
}]);
