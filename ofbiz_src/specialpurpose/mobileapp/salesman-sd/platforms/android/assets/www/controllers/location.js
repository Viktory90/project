/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('LocationController', ["$rootScope", "$scope", "$controller", 'uiGmapGoogleMapApi', "LoadRoadService", "GPS",
function($rootScope, $scope, $controller, GoogleMapApi, LoadRoadService, GPS) {
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
	$scope.currentLocation = {};
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader('Maps', "/main", false);
		$scope.height = 860;
		$scope.disableScrollX();
		$scope.disableScrollY();
		$('#content').bind('touchstart',function(){
			snapper.disable();
		});
		$('#content').bind('touchend',function(){
			snapper.enable();
		});
		$('#content').bind('touchcancel',function(){
			snapper.enable();
		});
		GPS.getCurrentLocation($scope, false);
	});
	$scope.$watch("currentLocation", function(){
			console.log("get location focus" + JSON.stringify($scope.currentLocation));
		if($scope.focus && $scope.currentLocation.lat && $scope.currentLocation.long){
			$scope.focus($scope.currentLocation.lat, $scope.currentLocation.long);
			console.log("on focus");
		}
	});
	// $scope.$watch('roadid', function() {
		// if ($scope.roadid && $scope.roadid !== '') {
// 			
		// }
	// });
	$scope.$watch("customers", function() {
		var data = [];
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
				data.push(obj);
			}
		}
		if ($scope.setMarkers) {
			$scope.setMarkers(data);
		}
	});
}]);
