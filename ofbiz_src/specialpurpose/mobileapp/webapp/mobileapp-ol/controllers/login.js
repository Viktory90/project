/*global todomvc, angular */

'use strict';
/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('LoginController', function($rootScope, $scope, $controller, $location, AuthService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$rootScope.isHeader = false;
	$scope.credentials = {
		USERNAME : '',
		PASSWORD : ''
	};
	$rootScope.login = true;
	$scope.$on("$viewContentLoaded", function() {
		$scope.hideSidebar();
	});
	$scope.$on('$includeContentLoaded', function() {
		$scope.loginBox = angular.element(document.querySelector('#login-form'));
		$scope.forgotBox = angular.element(document.querySelector('#forgot-form'));
		$scope.registerBox = angular.element(document.querySelector('#register-form'));
		$scope.listBox = angular.element(document.querySelectorAll('.widget-box'));
	});
	$scope.info = [];
	$scope.login = function() {
		var username = $scope.credentials.USERNAME;
		var password = $scope.credentials.PASSWORD;
		console.log("user info11 " + username.toLowerCase() + password.toLowerCase());
		$scope.credentials = {
			USERNAME : username.toLowerCase(),
			PASSWORD : password.toLowerCase()
		};
		$scope.info.push({
			USERNAME : username.toLowerCase(),
			PASSWORD : password.toLowerCase()
		});
		AuthService.login($scope.credentials).then(function(res) {
			if (res._LOGIN_PASSED_) {
					AuthService.loginSup($scope.info,$rootScope.showLoading).then(function(res) {
						$scope.info = new Array();
						$rootScope.hideLoading();
						if(res.result.checked){
							$location.path("/store");	
						}else $rootScope.openDialog('Login False');
					}, function() {
						$scope.info  = new Array();
						$rootScope.hideLoading();
						$rootScope.openDialog('Login False');
					});
					
			} else {
				$rootScope.openDialog('Login False');
			}
		}, function() {
			$rootScope.openDialog('Login False');
		});
	};
	$scope.changeState = function(state) {
		$scope.listBox.removeClass('visible');
		switch (state) {
		case 0:
			$scope.loginBox.addClass('visible');
			break;
		case 1:
			$scope.forgotBox.addClass('visible');
			break;
		case 2:
			$scope.registerBox.addClass('visible');
			break;
		}
	};
});
olbius.directive('ngEnter', function() {
	return function(scope, element, attrs) {
		element.bind("keydown keypress", function(event) {
			if (event.which === 13) {
				scope.$apply(function() {
					scope.$eval(attrs.ngEnter);
				});
				event.preventDefault();
			}
		});
	};
}); 