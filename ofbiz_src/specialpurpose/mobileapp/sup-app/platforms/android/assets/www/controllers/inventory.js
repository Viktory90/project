/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('InventoryController', function($rootScope, $scope, $controller, $location, $routeParams, InventoryService, ProductService, GPS, SqlService) {
	/* extends base controller */
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.isFinish = $routeParams.isFinish;
	$scope.currentStore = null;
	$scope.isValidDistance = false;
	$scope.isInventory = false;
	$scope.products = null;
	$scope.previousInventory = null;
	$scope.currentInventory = null;
	$scope.keyword = "";
	$scope.ads = {
		posm : "true",
		marketing : "true"
	};
	/* init function */

	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Inventory", "/store", false);
		if (!localStorage.customers) {
			$location.path("store");
		} else {
			$scope.currentStore = JSON.parse(localStorage.getItem("currentCustomer"));
		}
		$scope.getLastInventory();
		$scope.reloadDistance();
		$scope.initProduct();
		if($scope.currentStore.partyIdTo){
			$scope.isModified($scope.currentStore.partyIdTo,'modified');
		}
	});
	/* check if keyword filter */
	$scope.$on("keyword", function(event, arg) {
		$scope.keyword = arg.keyword;
	});
	/* init product */
	$scope.initProduct = function() {
		
		var data = [];
		if (localStorage.products) {
			data = JSON.parse(localStorage.getItem("products"));
		} else {
					$scope.getAllProduct();
				if (localStorage.products) {
					data = JSON.parse(localStorage.getItem("products"));
				}
			};
		if (data) {
			for (var x in data) {
				data[x].quantity = 0;
			}
			$scope.products = data;
		}
	};
	$scope.getAllProduct = function() {
		ProductService.getAll(function() {
		}).then(function(res) {
			if (res.listProduct) {
				$scope.products = res.listProduct;
				localStorage.setItem("products", JSON.stringify(res.listProduct));
			}
		}, function(res) {
			log("error" + JSON.stringify(res));
		});
	};
	/* get latest check inventory of salesman */
	$scope.getLastInventory = function() {
		if ($scope.currentStore) {
			// var key = "inventory_" + $scope.currentStore.partyIdTo;
			// if (localStorage[key] && !localStorage.isCreatedOrder) {
				// var data = JSON.parse(localStorage[key]);
				// $scope.initInventoryDate(data);
			// } else {
					if($rootScope.network.status){
						InventoryService.getByCustomer($scope.currentStore.partyIdTo, $rootScope.showLoading).then(function(res) {
						$rootScope.hideLoading();
						if (res.inventoryCusInfo && res.inventoryCusInfo.length != 0) {
							var data = res.inventoryCusInfo;
							$scope.initInventoryDate(data);
							// localStorage.setItem(key, JSON.stringify(res.inventoryCusInfo));
						} else {
							$scope.isInventory = true;
						}
	
					}, function(res) {
						log("inventory" + JSON.stringify(res));
						$rootScope.hideLoading();
					});
				}else{
					var query = "SELECT * FROM inventories WHERE customerId = '" + $scope.currentStore.partyIdTo + "'";
					SqlService.query(query).then(function(data){
						if(data && data.length){
							$scope.isInventory = false;
							$scope.initInventoryDate(data);
						}else $scope.isInventory = true;	
					},function(err){
						console.log('error'  + JSON.stringify(err));
					});
				}
		}
	};
	$scope.initInventoryDate = function(data) {
		var res = Array();
		for (var x in data) {
			var obj = {
				ivid : data[x].ivid,
				productId : data[x].productId,
				productName : data[x].productName,
				orderDate : data[x].orderDate,
				qtyInInventory : data[x].qtyInInventory,
				orderId : data[x].orderId,
				customerId : data[x].partyId,
				max : data[x].qtyInInventory
			};
			res.push(obj);
		}
		$scope.previousInventory = JSON.parse(JSON.stringify(res));
		$scope.currentInventory = res;
	};
	/*check current inventory < last inventory*/
	$scope.addProductToInventoryList = function(product) {
		var obj = {
			productId : product.productId,
			qtyInInventory : 0,
			productName : product.productName,
			expiryDate : ""
		};
		$scope.currentInventory.push(obj);
	};
	/*remove inventory product from list*/
	/*$scope.swipeToDelete = function(product) {
	 $scope.currentInventory.splice($scope.currentInventory.indexOf(product), 1);
	 };*/
	/*reload distance of salesman to store*/
	$scope.reloadDistance = function() {
		if ($scope.currentStore) {
			var point = {
				lat : $scope.currentStore.latitude,
				long : $scope.currentStore.longitude
			};
			GPS.checkDistance($scope, point);
		}
	};

	/* check inventory */
	var modifiedStep = false;
	$scope.checkInventory = function() {
		var inven = Array();
		var input = new Array();
		var tmp = Array();
		var input1= new Array();
		var tmp1 = Array();
		var checkinfo = false;
		var lastCheck = new Date().getTime();
		for (var x in $scope.currentInventory) {
			if($scope.currentInventory[x].qtyInInventory){
				checkinfo = true;
				tmp = [$scope.currentInventory[x].productId,$scope.currentInventory[x].productName,$scope.currentInventory[x].qtyInInventory, $scope.currentInventory[x].orderId ,lastCheck,$scope.currentStore.partyIdTo ,$scope.currentInventory[x].orderDate, "modified"];
				tmp1 = [$scope.currentInventory[x].productId,$scope.currentInventory[x].productName,$scope.currentInventory[x].qtyInInventory, $scope.currentInventory[x].orderId ,lastCheck,$scope.currentStore.partyIdTo ,$scope.currentInventory[x].orderDate, "init"];
			}else {
				checkinfo = false;
				$scope.isInventory = false;
				$rootScope.openDialog($rootScope.Map.NotiInventory[$rootScope.key]);
				// bootbox.alert($rootScope.Map.NotiInventory[$rootScope.key]);
			};	
			inven.push({
			 productId : $scope.currentInventory[x].productId,
			 productName : $scope.currentInventory[x].productName,
			 qtyInInventory : $scope.currentInventory[x].qtyInInventory,
			 orderId : $scope.currentInventory[x].orderId
			 });
			input.push(tmp);
			input1.push(tmp1);
		}
		if ($scope.currentStore && checkinfo) {
			var flag = $rootScope.network.status;
			if(!modifiedStep){	
						if(flag){
								InventoryService.check(inven, $scope.currentStore.partyIdTo, $rootScope.showLoading).then(function(data) {
									 $rootScope.hideLoading();
									 if (data.retMsg == "update_success") {
									 	$scope.deleteInventoryWith($scope.currentStore.partyIdTo);
									 	$scope.insertInventoryOffline(input1,flag);
									 	$scope.isInventory = true;
										 // bootbox.alert($rootScope.Map.NotiInventorySuccess[$rootScope.key]);
										 $rootScope.openDialog($rootScope.Map.NotiInventorySuccess[$rootScope.key]);
										 // var key = "inventory_" + $scope.currentStore.partyIdTo;
										 // localStorage.setItem(key, JSON.stringify($scope.currentInventory));
										 $rootScope.hideLoading();
									 } else {
										// bootbox.alert($rootScope.Map.NotiInventoryError[$rootScope.key]);
										$rootScope.openDialog($rootScope.Map.NotiInventoryError[$rootScope.key]);
										$rootScope.hideLoading();
									 }	
								 }, function() {
									 $scope.isInventory = true;
									 $rootScope.openDialog($rootScope.Map.NotiInventoryError[$rootScope.key]);
									 // bootbox.alert($rootScope.Map.NotiInventoryError[$rootScope.key]);
									 var data = {
										 product : $scope.products,
										 customer : $scope.customer
									 };
									 $rootScope.hideLoading();
				//					 $scope.addToStack(data, 'inventories');
								 });
							}else  if(checkinfo){
								$scope.insertInventoryOffline(input,flag);
							}
				}else{
					if(flag){
							BootstrapDialog.show({
								title : $rootScope.Map.Notification[$rootScope.key],
					            message: $rootScope.Map.RequiredSynchronizeAfterCheckInventory[$rootScope.key],
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
					                    dialogRef.getModalBody().html($rootScope.Map.MoveSynchronize[$rootScope.key]);
					                    setTimeout(function(){
					                        dialogRef.close();
					                        $location.path('sync');
					                        $scope.$apply();
					                    }, 2000);
					                }
					            }, {
					            	icon : 'fa fa-ban',
					                label: $rootScope.Map.Cancel[$rootScope.key],
					                action: function(dialogRef){
					                    dialogRef.close();
					                }
					            }]
					        }); 
					}else{
						$scope.insertInventoryOffline(input,flag);
					}
				}
			
		}
	};
	$scope.deleteInventoryWith = function(customerId){
		var cond = "customerId ='" + customerId +"'";
		SqlService.deleteRow('inventories',cond).then(function(data){
			console.log('delete success lvlvlv');
		},function(){
			console.log('delete error');
		});
	};
	$scope.isComplete = false;
	$scope.$watch('isComplete',function(){
		if($scope.isComplete){
			modifiedStep = true;
		}else modifiedStep = false;
	});
	$scope.isModified = function(customerId,status){
		var cond = "SELECT * FROM inventories WHERE customerId ='" + customerId +"' AND status = '" + status + "'";
			SqlService.query(cond).then(function(data){
			console.log(data.length+'isModified' + JSON.stringify(data));
			if(data.length > 0 ){
				$scope.isComplete = true ; 
			}else $scope.isComplete = false;
		},function(){
			$scope.isComplete = false ; 
		});
	};
	$scope.insertInventoryOffline = function(input,flag){
		$rootScope.showLoading();
		var query = "SELECT * FROM inventories";
		var fieldsInven = ["productId","productName","qtyInInventory","orderId","lastCheck","customerId","orderDate","status"];
		if(!flag){
			$scope.deleteInventoryWith($scope.currentStore.partyIdTo);
		}
		SqlService.insert('inventories',fieldsInven,input).then(function(data){
			$rootScope.hideLoading();
			$scope.isInventory = true;
			if(!flag && data){
				$rootScope.openDialog($rootScope.Map.NotiInventoryOfflineSuccess[$rootScope.key]);
				// bootbox.alert($rootScope.Map.NotiInventoryOfflineSuccess[$rootScope.key]);
			}
		},function(err){
			$rootScope.openDialog($rootScope.Map.NotiInventoryOfflineError[$rootScope.key]);
			// bootbox.alert($rootScope.Map.NotiInventoryOfflineError[$rootScope.key]);
		});
		
	};
	
	$scope.isValueInventory = function() {
		if ($scope.currentStore) {
			var key = "inventory" + $scope.currentStore.partyIdTo;
			var current = localStorage.getItem(key);
			if (!current) {
				return true;
			} else if (JSON.stringify($scope.currentInventory) == current) {
				return false;
			}
			return true;
		} else {
			bootbox.alert("Thông tin khách hàng không đúng");
			return false;
		}

	};
	$scope.createOrder = function(action) {
		if (action && action == "copy" && $scope.currentStore) {
			var key = "creatingorder_" + $scope.currentStore.partyIdTo;
			var data = Array();
			if ($scope.currentInventory && $scope.previousInventory) {
				if ($scope.currentInventory.length < $scope.previousInventory.length) {
					data = $scope.calculateOrder($scope.currentInventory, $scope.previousInventory);
				} else {
					data = $scope.calculateOrder($scope.previousInventory, $scope.currentInventory);
				}
				if (data.length) {
					localStorage.setItem(key, JSON.stringify(data));
				}
			}
		}
		$location.path('/order/create');
	};
	$scope.calculateOrder = function(min, max) {
		var res = Array();
		var remain = 0;
		for (var x in max) {
			var obj = JSON.parse(JSON.stringify(max[x]));
			var old = $scope.findProduct(min, obj.productId);
			if (old) {
				remain = Math.abs(obj.qtyInInventory - old.qtyInInventory);
				obj.qtyInInventory = remain;
			}
			res.push(obj);
		}
		return res;
	};
	$scope.findProduct = function(data, key) {
		var res = _.where(data, {
			productId : key
		});
		if (res.length) {
			var obj = {};
			var total = 0;
			for (var x in res) {
				obj = res[x];
				total += res[x].qtyInInventory;
			}
			obj.qtyInInventory = total;
			return obj;
		}
	};
});

/*if (!$scope.currentInventory[x].qtyInInventory || !$scope.currentInventory[x].expiryDate) {
 if ($scope.currentInventory[x].expiryDate) {
 if (!$scope.currentInventory[x].quantity) {
 error = true;
 $("#quantity" + $scope.currentInventory[x].productId).addClass("error");
 } else {
 $("#quantity" + $scope.currentInventory[x].productId).removeClass("error");
 }
 } else if ($scope.currentInventory[x].qtyInInventory) {
 if (!$scope.currentInventory[x].expiryDate) {
 error = true;
 $("#date" + $scope.currentInventory[x].productId).addClass("error");
 } else {
 $("#date" + $scope.currentInventory[x].productId).removeClass("error");
 }
 }
 } else {
 var dt = formatDateDMY($scope.currentInventory[x].expiryDate);
 inven.push({
 productId : $scope.currentInventory[x].productId,
 qtyInInventory : $scope.currentInventory[x].qtyInInventory,
 expireDate : dt
 });
 }*/