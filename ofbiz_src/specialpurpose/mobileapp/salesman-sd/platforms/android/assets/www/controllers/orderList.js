/*global todomvc, angular */
'use strict';
/**
 * The order controller for the order & create order screen. The controller:
 * Retrieves and persists the model via the order service
 */

/* controller for orders screen */
olbius.controller('OrderController', function($rootScope, $routeParams, $scope, $controller, $location, $window, OrderService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.iscurrent = $.parseJSON($routeParams.iscurrent);
	$scope.listOrder = {
		content : Array(),
		total : 0,
		size : 0,
		totalOrderCreate : 0,
		totalOrderApproved : 0,
		totalOrderCancel : 0,
		totalPayCreate : 0,
		totalPayApproved : 0,
		totalPayCancel : 0,
		payAmount : 0
	};
	$scope.timeViewOrder = [
		{
			text : $rootScope.Map.Thisweek[$rootScope.key],
			value : 'thisweek'
		},
		{
			text : $rootScope.Map.Thismonth[$rootScope.key],
			value : 'thismonth'
		}
	];
	
	$scope.val = $scope.timeViewOrder[0].value;
	$scope.loading = false;
	$scope.currentCustomer = null;
	$scope.currentPage = 0;
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader('OrderList', "/main", false);
		var currentCustomer = localStorage.getItem('currentCustomer');
			$scope.init();
			$scope.scroll();
	});
	$scope.$watch('val',function(){
	// $scope.getListOrder = function(){
		if($rootScope.network.status){
			$scope.listOrder.content  = new Array();
			$scope.listOrder.total = 0;
			$scope.listOrder.size = 0;
			$scope.listOrder.totalOrderCreate  = 0 ;
			$scope.listOrder.totalOrderApproved = 0;
			$scope.listOrder.totalOrderCancel= 0;
			$scope.listOrder.totalPayCreate =0 ;
			$scope.listOrder.totalPayApproved = 0 ;
			$scope.listOrder.totalPayCancel = 0;
			$scope.listOrder.payAmount = 0;
			OrderService.getList($rootScope.showLoading, $rootScope.configPage.index,$rootScope.configPage.pageSize,$scope.val).then(function(data) {
					for (var x in data.orderHeaderList){
							$scope.listOrder.size ++;
							$scope.listOrder.payAmount += data.orderHeaderList[x].grandTotal;
						if(data.orderHeaderList[x].statusId == 'ORDER_CREATED'){
							$scope.listOrder.totalOrderCreate++;
							$scope.listOrder.totalPayCreate += data.orderHeaderList[x].grandTotal;
						}else if(data.orderHeaderList[x].statusId == 'ORDER_APPROVED'){
							$scope.listOrder.totalOrderApproved++;
							$scope.listOrder.totalPayApproved += data.orderHeaderList[x].grandTotal;
						}else if(data.orderHeaderList[x].statusId == 'ORDER_CANCELLED'){
							$scope.listOrder.totalOrderCancel++;
							$scope.listOrder.totalPayCancel += data.orderHeaderList[x].grandTotal;
						}
						$scope.listOrder.content.push(data.orderHeaderList[x]);
					}
					$rootScope.hideLoading();
					console.log('111' + $scope.listOrder.payAmount);
				$scope.listOrder.total = data.total;
			}, function() {
				$rootScope.hideLoading();
			});
		}else {
			BootstrapDialog.show({
								title : $rootScope.Map.Notification[$rootScope.key],
					            message: $rootScope.Map.FunctionForNetwork[$rootScope.key],
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
					                    // dialogRef.getModalBody().html($rootScope.Map.MoveSynchronize[$rootScope.key]);
					                        dialogRef.close();
					                }
					            }]
					        }); 
		}
	});
	/*bind keyword changed*/
	$scope.$on("keyword", function(arg) {
		console.log(arg);
	});
	/*bind scroll*/

	$scope.scroll = function() {
		var obj = angular.element($window);
		var bottom = angular.element($("#bottom"));
		obj.bind("scroll", function(res) {
			if ((this.pageYOffset + $(window).height()) == $(document).height()) {
				$scope.loadMore();
			}
		});
	};
	$scope.listCustomer = {};
	/*init list Order*/
	$scope.init = function() {
		if(localStorage.getItem('customers')){
			$scope.listCustomer = $.parseJSON(localStorage.getItem('customers'));
		}
		if (localStorage.currentCustomer) {
			$scope.currentCustomer = JSON.parse(localStorage.getItem("currentCustomer"));
			var key = "listOrder";
			// if ($scope.iscurrent) {
				// key = "currentListOrder";
			// }
			// if (localStorage.getItem(key) && $scope.iscurrent == $.parseJSON(localStorage.getItem("iscurrent"))) {
			if (localStorage.getItem(key)) {
				var list = JSON.parse(localStorage.getItem(key));
				if (list && list.content.length) {
					$scope.listOrder = list;
					var length = list.content.length;
					$scope.currentPage = Math.ceil(length / config.pageSize);
				} else {
					$scope.loadMore(true);
				}
			} else {
				$scope.loadMore(true);
			}
			if ($scope.iscurrent) {
				localStorage.setItem("iscurrent", $scope.iscurrent);
			}
		}
	};
	/*get data from server*/
	$scope.getData = function(status) {
		if (!status) {
			var refresh = $rootScope.showLoading;
			var close = $rootScope.hideLoading;
		} else {
			var refresh = function() {
				$scope.loading = true;
				$("#refresh").addClass("rotate");
			};
			var close = function() {
				$scope.loading = false;
				$("#refresh").removeClass("rotate");
			};
		}
		$scope.getList(refresh, close);
	};
	$scope.getList = function(refresh, close) {
		// var partyId = "";
		// var key = "listOrder";
		// if ($scope.iscurrent && $scope.currentCustomer) {
			// partyId = $scope.currentCustomer.partyIdTo;
			// key = "currentListOrder";
		// }
		if($rootScope.network.status){
				OrderService.getList(refresh, $rootScope.configPage.index,$rootScope.configPage.pageSize,'thisweek').then(function(data) {
					// if (data.orderHeaderList[x].status) {
						// data.orderHeaderList[x].status = $rootScope.Map.Paid[$rootScope.key];
						// $scope.listOrder.pay++;
						// $scope.listOrder.payAmount += data.orderHeaderList[x].grandTotal;
					// } else {
						// data.orderHeaderList[x].status = $rootScope.Map.Unpaid[$rootScope.key];
						// $scope.listOrder.debt++;
						// $scope.listOrder.debtAmount += data.orderHeaderList[x].grandTotal;
					// }
					// $scope.listOrder.content.push(data.orderHeaderList[x]);
					for (var x in data.orderHeaderList){
							$scope.listOrder.size ++;
							$scope.listOrder.payAmount += data.orderHeaderList[x].grandTotal;
						if(data.orderHeaderList[x].statusId == 'ORDER_CREATED'){
							$scope.listOrder.totalOrderCreate++;
							$scope.listOrder.totalPayCreate += data.orderHeaderList[x].grandTotal;
						}else if(data.orderHeaderList[x].statusId == 'ORDER_APPROVED'){
							$scope.listOrder.totalOrderApproved++;
							$scope.listOrder.totalPayApproved += data.orderHeaderList[x].grandTotal;
						}else if(data.orderHeaderList[x].statusId == 'ORDER_CANCELLED'){
							$scope.listOrder.totalOrderCancel++;
							$scope.listOrder.totalPayCancel += data.orderHeaderList[x].grandTotal;
						}
						$scope.listOrder.content.push(data.orderHeaderList[x]);
					}
				console.log('listordercontent' + JSON.stringify($scope.listOrder));
				$scope.listOrder.total = data.total;
				//set number page
				// $scope.listOrder.size = data.size;
				// localStorage.setItem(key, JSON.stringify($scope.listOrder));
				close();
			}, function() {
				close();
			});
		}else {
			var query = "SELECT * FROM orderView";
			SqlService.query(query).then(function(data){
				console.log('list offline' +JSON.stringify( data));
				for (var x in data) {
					$scope.listOrder.size ++;
					$scope.listOrder.payAmount += data[x].grandTotal;
					if(data[x].statusId == 'ORDER_CREATED'){
						$scope.listOrder.totalOrderCreate++;
						$scope.listOrder.totalPayCreate += data[x].grandTotal;
					}else if(data[x].statusId == 'ORDER_APPROVED'){
						$scope.listOrder.totalOrderApproved++;
						$scope.listOrder.totalPayApproved += data[x].grandTotal;
					}else if(data[x].statusId == 'ORDER_CANCELLED'){
						$scope.listOrder.totalOrderCancel++;
						$scope.listOrder.totalPayCancel += data[x].grandTotal;
					}
					$scope.listOrder.content.push(data[x]);
				}
			},function(){
				
			});
		}
		
	};
	/*load more data when scroll to bottoms*/
	$scope.loadMore = function(init) {
		if ($scope.listOrder.total && $scope.listOrder.content.length) {
			if ($scope.currentPage < $scope.listOrder.total) {
				$scope.currentPage++;
				$scope.getData(true);
			}
		} else if (init) {
			$scope.getData();
		}

	};
	$scope.onSelectRow = function(id) {
		if($rootScope.network.status){
			$location.path('order/detail/' + id);	
		}else {
			BootstrapDialog.show({
								title : $rootScope.Map.Notification[$rootScope.key],
					            message: $rootScope.Map.NotiViewOrder[$rootScope.key],
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
					                    // dialogRef.getModalBody().html($rootScope.Map.MoveSynchronize[$rootScope.key]);
					                        dialogRef.close();
					                }
					            }]
					        }); 
		}
		
		//$scope.$apply();
	};
});