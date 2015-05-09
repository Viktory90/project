/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('HeaderController', function($rootScope, $scope, $location, $controller, AuthService) {

	$scope.$on('$includeContentLoaded', function() {
	});
	$scope.keyword = "";
	if($rootScope.isFilterable){
		$scope.$watch("keyword", function() {
		$rootScope.$broadcast("keyword", {
			keyword : $scope.keyword
			});
		});
	}	
	$scope.broadcast = function() {
		if ($scope.keyword) {
			$rootScope.$broadcast("keyword", function() {
			});
		}
	};
	/*show sidebar left*/
	$scope.showLeftBar = function() {
		snapper.open('left');
	};

	$scope.getNotification = function() {
		if (localStorage.notification) {
			$scope.employee.notification = localStorage.getItem('notification');
			return;
		}
		EmployeeService.getNotification().then(function(res) {
			var notification = Array();
			for (var x = 1; x <= 3; x++) {
				notification.push({
					content : res["middleTopMessage" + x],
					link : res['middleTopLink2' + x]
				});
			}
			$scope.employee.notification = notification;
			localStorage.setItem('notification', JSON.stringify(notification));
		});
	};
	/* show search input when click search */
	$scope.showSearch = function() {
		var search = $(".search");
		var obj = $(".search-input");
		obj.addClass("search-input-animation");
		search.css("z-index", "5");
		//$(".search-input-text").focus();
	};
	/* hide search input when click outside */
	$scope.removeSearch = function() {
		var obj = $(".search-input");
		var search = $(".search");
		search.css("z-index", "1");
		obj.removeClass("search-input-animation");
	};
});
