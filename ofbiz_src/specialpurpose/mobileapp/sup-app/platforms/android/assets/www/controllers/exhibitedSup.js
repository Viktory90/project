/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('MarkExhibitedSupController', function($rootScope,$route, $scope, $controller, ProductService, CustomerService ,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader('Exhibited', "/sale", false);
		$scope.inIt();
	});
	$scope.inIt = function() {
		$scope.getAllStore();
		$scope.getListMarkedBySalesMan();
	};
	$scope.cancel = function(){
		$route.reload();
	};
	$scope.customers = {
		customerName : "",
		customerId : "",
		productPromoId : "",
		ruleId : "",
		ruleName : "",
		quantity : "",
		productId : "",
		productName : "",
		fromDate : "",
		thruDate : "",
		promoName : "",
		createdDate : ""
	};
	$scope.exhibited = {
		info : [],
		rule : [],
		list : [],
		showExhibited : false,
		showRule : false,
		showDetail : false,
		showMark : false
	};
	$scope.infoExhibitedMarks = {
		promoRegisterId : "",
		promoName : "",
		promoId : "",
		ruleId : "",
		createdDate : "",
		createdBy : "",
		isSequency : "",
		result : "",
		customerName : ""
	};
	$scope.image = {};
	$scope.listMarked = [];
	$scope.getListMarkedBySalesMan =  function(){
		ProductService.getListMarkedBySalesMan($rootScope.showLoading).then(function(data){
			$rootScope.hideLoading();
			if(data.list && data.list.length > 0 ){
				for(var key in data.list){
					$scope.listMarked.push({
						promoName : data.list[key].promoName,
						productPromoRuleId : data.list[key].productPromoRuleId,
						createdBy : data.list[key].createdBy,
						createdDate : formatDateDMY(data.list[key].createdDate.time),
						productPromoRegisterId : data.list[key].productPromoRegisterId,
						isSequency : data.list[key].isSequency,
						result : data.list[key].result,
						groupName : data.list[key].groupName
					});
				}
			}
		},function(err){
			
		});
	};
	$scope.$watch('infoExhibitedMarks.promoRegisterId', function() {
		if ($scope.infoExhibitedMarks.promoRegisterId) {
			$scope.exhibited.showMark = true;
			var date = formatDateYMD(new Date().getTime());
			if($rootScope.network.status){
				for (var item in $scope.exhibited.list) {
					if ($scope.infoExhibitedMarks.promoRegisterId == $scope.exhibited.list[item].productPromoRegisterId) {
							$scope.infoExhibitedMarks.promoName = $scope.exhibited.list[item].promoName;
							$scope.infoExhibitedMarks.promoId = $scope.exhibited.list[item].promoId;
							$scope.infoExhibitedMarks.ruleId = $scope.exhibited.list[item].ruleId;
							$scope.infoExhibitedMarks.createdDate = date;
							$scope.infoExhibitedMarks.createdBy = $scope.exhibited.list[item].createBy;
							$scope.infoExhibitedMarks.customerName = $scope.exhibited.list[item].customerName;
					}
				};
			}else{
				for (var item in $scope.exhibited.list) {
					if ($scope.infoExhibitedMarks.promoRegisterId == $scope.exhibited.list[item].productPromoRegisterId) {
							$scope.infoExhibitedMarks.promoName = $scope.exhibited.list[item].promoName;
							$scope.infoExhibitedMarks.promoId = $scope.exhibited.list[item].promoId;
							$scope.infoExhibitedMarks.ruleId = $scope.exhibited.list[item].ruleId;
							$scope.infoExhibitedMarks.createdDate = date;
							$scope.infoExhibitedMarks.customerName = $scope.exhibited.list[item].customerName;
							$scope.infoExhibitedMarks.createdBy = $scope.exhibited.list[item].createBy;
					}
				};
			} 
		} else
			$scope.exhibited.showMark = false;
	});
	$scope.cancel = function(){
		$route.reload();
	};
	$scope.$watch('customers.customerId', function() {
		//reset data
		$scope.exhibited.info = new Array();
		$scope.exhibited.list = new Array();
		$scope.infoExhibitedMarks = new Object();
		$scope.getExhibitedForMark($scope.customers.customerId);
		//clear Array empty when call Ajax
		if ($scope.customers.customerId) {
			for(var key in $scope.customers.content){
				if($scope.customers.customerId == $scope.customers.content[key].partyIdTo){
					$scope.customers.customerName = $scope.customers.content[key].groupName;
					break;
				}
			}
			$scope.getListExhibited();
			$scope.exhibited.showExhibited = true;
		}else
			$scope.exhibited.showExhibited = false;
	});
	$scope.$watch('customers.productPromoId', function() {
		$scope.exhibited.rule = new Array();
		if ($scope.customers.productPromoId) {
			$scope.exhibited.showRule = true;
			if($rootScope.network.status){
				for (var key in $scope.exhibited.content) {
				if ($scope.customers.productPromoId == $scope.exhibited.content[key].productPromoId) {
					$scope.exhibited.rule.push({
							ruleId : $scope.exhibited.content[key].productPromoRuleId,
						});
					}
				};
			}else{
				for (var key in listExhibitedOffline) {
					if ($scope.customers.productPromoId == listExhibitedOffline[key].productPromoId) {
						$scope.exhibited.rule.push({
							ruleId : listExhibitedOffline[key].productPromoRuleId,
							});
						}
				};
				
			}
		}else 
			{
				 $scope.exhibited.showRule = false;	
			}
	});
	$scope.$watch('customers.ruleId', function() {
		if ($scope.customers.ruleId) {
			$scope.exhibited.showDetail = true;
			if($rootScope.network.status){
				for (var key in $scope.exhibited.content) {
					if ($scope.customers.ruleId == $scope.exhibited.content[key].productPromoRuleId) {
								$scope.customers.ruleName = $scope.exhibited.content[key].ruleName;
								$scope.customers.productId = $scope.exhibited.content[key].productId;
								$scope.customers.productName = $scope.exhibited.content[key].productName;
								$scope.customers.quantity = $scope.exhibited.content[key].quantity;
								$scope.customers.fromDate = formatDateDMY($scope.exhibited.content[key].fromDate.time);
								$scope.customers.thruDate = formatDateDMY($scope.exhibited.content[key].thruDate.time);
								$scope.customers.productPromoTypeId = $scope.exhibited.content[key].productPromoTypeId;
								$scope.customers.promoName = $scope.exhibited.content[key].promoName;
						}
				};
			}else{
				for (var key in listExhibitedOffline) {
					if ($scope.customers.ruleId == listExhibitedOffline[key].productPromoRuleId) {
								$scope.customers.ruleName = listExhibitedOffline[key].ruleName;
								$scope.customers.productId = listExhibitedOffline[key].productId;
								$scope.customers.productName = listExhibitedOffline[key].productName;
								$scope.customers.quantity = listExhibitedOffline[key].quantity;
								$scope.customers.fromDate = listExhibitedOffline[key].fromDate;
								$scope.customers.thruDate = listExhibitedOffline[key].thruDate;
								$scope.customers.productPromoTypeId = listExhibitedOffline[key].productPromoTypeId;
								$scope.customers.promoName = listExhibitedOffline[key].promoName;
						}
				};
			};
		} else $scope.exhibited.showDetail = false;
	});
	$scope.listCustomers = {};	
	$scope.getAllStore = function() {
		if($rootScope.network.status){
			if(localStorage.getItem('listStore')){
				$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
				$scope.listCustomers = $.parseJSON(localStorage.getItem('listStore'));
			}else {
				CustomerService.getStoreByRoad(0, 100,'N',null).then(function(data) {
					$scope.customers.content = data.customers;
					$scope.listCustomers = data.customers;
				});
			};
		}else{
			$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
			$scope.listCustomers = $.parseJSON(localStorage.getItem('listStore'));
		};
	};
	var  listExhibitedOffline = {};
	$scope.getListExhibited = function() {
		var checkIn = false;
	if($rootScope.network.status){
		ProductService.getExhibitedDetail($scope.customers.customerId).then(function(data) {
			$scope.exhibited.content = data.listExhibited;
			for (var ex in $scope.exhibited.content){
				var arr = $scope.exhibited.info;
				if (arr.length > 0) {
					for (var i in arr) {
						if (arr[i].productPromoId == $scope.exhibited.content[ex].productPromoId) {
							checkIn = true;
						} else
							checkIn = false;
					}
					if (!checkIn) {
						arr.push({
							productPromoId : $scope.exhibited.content[ex].productPromoId,
							promoName : $scope.exhibited.content[ex].promoName,
						});
					}
				} else {
					arr.push({
						productPromoId : $scope.exhibited.content[ex].productPromoId,
						promoName : $scope.exhibited.content[ex].promoName,
					});
				}
			}
			$scope.exhibited.info = arr;
		});
	}else {
		//when offline
		var query = "SELECT * from exhibite";
		
			SqlService.query(query).then(function(data){
				listExhibitedOffline = data;
						if(listExhibitedOffline){
							for (var ex in listExhibitedOffline) {
								console.log('element exhibited' + JSON.stringify(listExhibitedOffline[ex]));
								var arr = $scope.exhibited.info;
								if (arr.length > 0) {
									for (var i in arr) {
										if (arr[i].productPromoId == listExhibitedOffline[ex].productPromoId) {
											checkIn = true;
										} else checkIn = false;
									};
									if (!checkIn) {
										arr.push({
											productPromoId : listExhibitedOffline[ex].productPromoId,
											promoName : listExhibitedOffline[ex].promoName
										});
									}
								}else{
									arr.push({
										productPromoId : listExhibitedOffline[ex].productPromoId,
										promoName : listExhibitedOffline[ex].promoName
									});
								}
					};
					$scope.exhibited.info = arr;
				};
				
			},function(err){
				console.log(JSON.stringify(err));
			});
		};
	};
	$scope.getDataExhibited = function(query){
		return SqlService.query(query).then(function(data){
			return JSON.stringify(data);
		},function(err){
			console.log(JSON.stringify(err));
			return JSON.stringify(err);
		});
	};
	$scope.changeTab1 = function() {
		$('#list1').addClass('active');
		$('#ExhibitedRegister').addClass('active');
		$('#list2').removeClass('active');
		$('#MarksExhibited').removeClass('active');
	};
	$scope.getExhibitedForMark = function(customerId) {
		$scope.exhibited.list = new Array();
		if($rootScope.network.status){
			ProductService.getExhibitedForMark(customerId).then(function(data) {
			if (data.result) {
				for (var rs in data.result) {
					$scope.exhibited.list.push({
						promoName : data.result[rs].promoName,
						promoId : data.result[rs].productPromoId,
						ruleId : data.result[rs].productPromoRuleId,
						createdDate : formatDateDMY(data.result[rs].createdDate.time),
						createBy : data.result[rs].createdBy,
						productPromoRegisterId : data.result[rs].productPromoRegisterId,
						customerName : data.result[rs].groupName
					});
				}
			}
		});
		}else{
			var query = "SELECT DISTINCT * FROM exhibitedForMark WHERE partyId ='"+customerId+"'";
			SqlService.query(query).then(function(data){
				console.log('vl' + JSON.stringify(data));
				for(var rs in data){
					$scope.exhibited.list.push({
						promoName : data[rs].promoName,
						promoId : data[rs].productPromoId,
						ruleId : data[rs].productPromoRuleId,
						createdDate : data[rs].createdDate,
						createBy : data[rs].createdBy,
						productPromoRegisterId : data[rs].productPromoRegisterId,
						customerName : data[rs].groupName
					});
				}	
			},function(err){
				console.log('get data exhibited register error');
			});
		}
	};
	
	$scope.changeTab2 = function() {
		var currentCustomer = {};
		$('#list2').addClass('active');
		$('#MarksExhibited').addClass('active');
		$('#list1').removeClass('active');
		$('#ExhibitedRegister').removeClass('active');
		currentCustomer = $.parseJSON(localStorage.getItem("currentCustomer"));
		
		if(currentCustomer){
			$scope.exhibited.list = new Array();
		} else $rootScope.openDialog($rootScope.Map.NotiSelectStoreRegisterExhibited[$rootScope.key]);
	};
	$scope.exhibitedRegister = function() {
		$rootScope.showLoading();
		//check in register not same DB
	if($rootScope.network.status){
		$scope.customers.createdDate = getCurrentDateYMD();
		ProductService.exhibitedRegister($scope.customers).then(function(data) {
			$rootScope.hideLoading();
			if(data.result){
				if (!data.result.duplicate) {
					$rootScope.openDialog($rootScope.Map.NotiExhibitedSuccess[$rootScope.key]);
				}else $rootScope.openDialog($rootScope.Map.NotiExhibitedRegistered[$rootScope.key]);
			}else $rootScope.openDialog($rootScope.Map.NotiExhibitedError[$rootScope.key]); 	
		},function(){
				$rootScope.hideLoading();
				$rootScope.openDialog($rootScope.Map.NotiExhibitedError[$rootScope.key]); 					
		});
	}else {
		var fields = ["customerName","customerId","productPromoId","ruleId","ruleName","quantity","productId","productName","fromDate","thruDate","promoName","createdDate"];
		var tmp = [];
		var input = [];
		$scope.customers.createdDate = getCurrentDateYMD();
		tmp = [$scope.customers.customerName,$scope.customers.customerId,$scope.customers.productPromoId,$scope.customers.ruleId,$scope.customers.ruleName,$scope.customers.quantity,$scope.customers.productId,$scope.customers.productName,$scope.customers.fromDate,$scope.customers.thruDate,$scope.customers.promoName,$scope.customers.createdDate];
		input.push(tmp);
		SqlService.insert('exhibitedRegister',fields,input).then(function(data){
			$rootScope.hideLoading();
			$rootScope.openDialog($rootScope.Map.NotiExhibitedSuccess[$rootScope.key]); 
		},function(err){
			$rootScope.hideLoading();
			$rootScope.openDialog($rootScope.Map.NotiExhibitedError[$rootScope.key]); 
		});
	}
	};
	$scope.sendMark = function() {
		if (!$scope.exhibited.showMark || !$scope.infoExhibitedMarks.isSequency || !$scope.infoExhibitedMarks.result) {
			$rootScope.openDialog($rootScope.Map.NotiPressInforRegister[$rootScope.key]); 
		} else if ($scope.infoExhibitedMarks) {
			$rootScope.showLoading();
			if($rootScope.network.status){
				ProductService.sendMark($scope.infoExhibitedMarks).then(function(data) {
				$rootScope.hideLoading();	
				if(data._ERROR_MESSAGE_){
					if(data._ERROR_MESSAGE_ == 'duplicate'){
						$rootScope.openDialog($rootScope.Map.NotiMarkingExhibited[$rootScope.key]); 
					}else $rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingError[$rootScope.key]); 
				}else {
					if (data.res) {
						$rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingSuccess[$rootScope.key]);
					} else $rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingError[$rootScope.key]);
				}
			});
			}else{
				var input = [];
				var fields = ["promoRegisterId","promoName","promoId","ruleId","createdDate","createdBy","isSequency","result","customerName"];
				var date = new Date().getTime();
				var value = [$scope.infoExhibitedMarks.promoRegisterId,$scope.infoExhibitedMarks.promoName,$scope.infoExhibitedMarks.promoId,$scope.infoExhibitedMarks.ruleId,formateDateYMD(date),$scope.infoExhibitedMarks.createdBy,$scope.infoExhibitedMarks.isSequency,$scope.infoExhibitedMarks.result,$scope.infoExhibitedMarks.customerName];
				input.push(value);
				$rootScope.hideLoading();
				if(input && input.length > 0){
					SqlService.insert('exhibitedMark',fields,input).then(function(res){
						$rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingSuccess[$rootScope.key]);
					},function(err){
						$rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingError[$rootScope.key]);
					});
				}else $rootScope.openDialog($rootScope.Map.NotiExhibitedMarkingError[$rootScope.key]);
			}
		}

	};
});
