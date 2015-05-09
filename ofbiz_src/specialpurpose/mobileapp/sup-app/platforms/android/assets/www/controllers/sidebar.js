/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('SidebarController', function($rootScope, $scope, $location, $window, $controller, EmployeeService, SqlService,AuthService) {
	$scope.employee = {};
	$scope.logout = function() {
		BootstrapDialog.show({
					title : $rootScope.Map.Notification[$rootScope.key],
		            message: $rootScope.Map.NotiConfirmLogout[$rootScope.key],
		            type : BootstrapDialog.TYPE_SUCCESS,
		            closable : false,
		            spinicon : 'fa fa-spinner',
		            buttons: [{
		                icon: 'glyphicon glyphicon-ok',
		                label: $rootScope.Map.Ok[$rootScope.key],
		                cssClass: 'btn-primary',
		                autospin: true,
		                action: function(dialogRef){
		                    dialogRef.enableButtons(false);
		                    dialogRef.setClosable(false);
		                    dialogRef.close();
							SqlService.dropTable('accumulate');
							SqlService.dropTable('accumulateRegister');
							SqlService.dropTable('customer');
							SqlService.dropTable('customerOpinion');
							SqlService.dropTable('exhibite');
							SqlService.dropTable('exhibitedRegister');
							SqlService.dropTable('exhibitedMark');
							SqlService.dropTable('exhibitedForMark');
							SqlService.dropTable('inventories');
							SqlService.dropTable('opponent');
							SqlService.dropTable('orderinfo');
							SqlService.dropTable('orderlist');
							SqlService.dropTable('products');
							SqlService.dropTable('promotions');
							SqlService.dropTable('forLeave');
							localStorage.clear();
							AuthService.logout().then(function() {
								$location.path("login");
							}, function(){
								$location.path("login");
							});
		                }
		            }, {
		            	icon : 'fa fa-ban',
		                label: $rootScope.Map.Cancel[$rootScope.key],
		                action: function(dialogRef){
		                    dialogRef.close();
		                }
		            }]
		        }); 
		// bootbox.confirm($rootScope.Map.NotiConfirmLogout[$rootScope.key],function(result){
			// if(result){
// 				
			// };
		// });
	};
	$scope.url = localStorage.getItem("serverUrl");
	console.log($scope.url);
	$scope.element = angular.element($('#left'));
	$scope.$watch("url", function() {
		if ($scope.url) {
			localStorage.setItem("serverUrl", $scope.url);
//			$window.location.reload();
		}
	});
	$rootScope.rootInfo = {};
	$scope.$watch('rootInfo',function(){
		if(!_.isEmpty($rootScope.rootInfo)){
			$scope.employee = $rootScope.rootInfo;
		}
	});
	$scope.getInfo = function() {
		if (localStorage.employee) {
			$scope.employee = JSON.parse(localStorage.getItem('employee'));
			return;
		}
		EmployeeService.getProfile().then(function(res) {
			if (res.hasOwnProperty('customerInfo')) {
				$scope.employee = res.customerInfo;
				localStorage.setItem('employee', JSON.stringify(res.customerInfo));
			}
		});
	};
	$scope.getAvatar = function() {
		if (localStorage.avatar) {
			$scope.employee.avatar = localStorage.getItem('avatar');
			return;
		}
		EmployeeService.getAvatar().then(function(res) {
			$scope.employee.avatar = res.contentImageUrl;
			localStorage.setItem('avatar', res.contentImageUrl);
		});
	};
	$scope.updateProfile = function() {
		$location.path('profile');
	};
	$scope.home = function() {
		$location.path("main");
	};
	$scope.inventory = function() {
		$location.path("store");
	};
	$scope.leave = function() {
		$location.path("employee-leave");
	};
	$scope.createCustomer = function() {
		$location.path("customer/create");
	};
	$scope.urlConfig = function() {
		localStorage.clear();
		if ($scope.url) {
			localStorage.setItem("serverUrl", $scope.url);
		}
		$scope.clearDB();
		$window.location.reload();
	};
	$scope.clearDB = function() {
		if (db) {
			for (var x in db) {
				SqlService.dropTable(db[x]);
			}
		}
	};
	$scope.getInfo();
});
