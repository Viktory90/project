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
	});
	$scope.$on('$includeContentLoaded', function() {
		$scope.loginBox = angular.element(document.querySelector('#login-form'));
		$scope.forgotBox = angular.element(document.querySelector('#forgot-form'));
		$scope.registerBox = angular.element(document.querySelector('#register-form'));
		$scope.listBox = angular.element(document.querySelectorAll('.widget-box'));
	});
	$scope.login = function() {
		var username = $scope.credentials.USERNAME;
		var password = $scope.credentials.PASSWORD;
		console.log("user info " + username.toLowerCase() + password.toLowerCase());
		$scope.credentials = {
			USERNAME : username.toLowerCase(),
			PASSWORD : password.toLowerCase()
		};
		console.log('cradentials' + JSON.stringify($scope.credentials));
		AuthService.login($scope.credentials).then(function(res) {
			if (res._LOGIN_PASSED_) {
				if(!localStorage.getItem('UserInfo')){
					localStorage.setItem('UserInfo',JSON.stringify($scope.credentials));	
				}
				$location.path("/store");
			} else {
				BootstrapDialog.show({
							title : $rootScope.Map.Notification[$rootScope.key],
				            message: $rootScope.Map.LoginFailed[$rootScope.key],
				            type : BootstrapDialog.TYPE_SUCCESS,
				            closable : true
				            // spinicon : 'fa fa-spinner',
				            // buttons: [{
				                // icon: 'glyphicon glyphicon-ok',
				                // label: $rootScope.Map.again[$rootScope.key],
				                // cssClass: 'btn-primary',
				                // autospin: true,
				                // action: function(dialogRef){
				                    // dialogRef.enableButtons(false);
				                    // dialogRef.setClosable(false);
				                        // dialogRef.close();
				                // }
				            // }]
				        }); 
				// alert('Login false');
			}
		}, function() {
			alert('Login false');
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