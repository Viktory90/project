/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ShowupController', function($rootScope, $scope, $controller, ProductService, CustomerService ,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Trưng bày", "/sale", false);
		$scope.inIt();
	});
	$scope.inIt = function() {
		$scope.getAllStore();
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
		result : ""
	};
	$scope.image = {};
	$scope.$watch('infoExhibitedMarks.promoRegisterId', function() {
		if ($scope.infoExhibitedMarks.promoRegisterId) {
			$scope.exhibited.showMark = true;
			console.log('promoREgisterid'+$scope.infoExhibitedMarks.promoRegisterId);
			if($rootScope.network.status){
				for (var item in $scope.exhibited.list) {
					if ($scope.infoExhibitedMarks.promoRegisterId == $scope.exhibited.list[item].productPromoRegisterId) {
							$scope.infoExhibitedMarks.promoName = $scope.exhibited.list[item].promoName;
							$scope.infoExhibitedMarks.promoId = $scope.exhibited.list[item].promoId;
							$scope.infoExhibitedMarks.ruleId = $scope.exhibited.list[item].ruleId;
							$scope.infoExhibitedMarks.createdDate = $scope.exhibited.list[item].createdDate;
							$scope.infoExhibitedMarks.createdBy = $scope.exhibited.list[item].createBy;
					}
				};
			}else{
				console.log('mark' + JSON.stringify($scope.infoExhibitedMarks));
				for (var item in $scope.exhibited.list) {
					if ($scope.infoExhibitedMarks.promoRegisterId == $scope.exhibited.list[item].productPromoRegisterId) {
							$scope.infoExhibitedMarks.promoName = $scope.exhibited.list[item].promoName;
							$scope.infoExhibitedMarks.promoId = $scope.exhibited.list[item].promoId;
							$scope.infoExhibitedMarks.ruleId = $scope.exhibited.list[item].ruleId;
							$scope.infoExhibitedMarks.createdDate = $scope.exhibited.list[item].createdDate;
							console.log('mark' + JSON.stringify($scope.infoExhibitedMarks));
					}
				};
			} 
			
			console.log($scope.infoExhibitedMarks);
		} else
			$scope.exhibited.showMark = false;
	});
	$scope.$watch('customers.customerId', function() {
		console.log($scope.customers.customerId);
		$scope.exhibited.info = new Array();
		//clear Array empty when call Ajax
		if ($scope.customers.customerId) {
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
			$scope.exhibited.showRule = false;
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
					console.log('fff1'+ JSON.stringify(listExhibitedOffline));
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
	$scope.getAllStore = function() {
		if($rootScope.network.status){
			if(localStorage.getItem('listStore')){
				$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
			}else {
				CustomerService.getAll(0, 100, null).then(function(data) {
					$scope.customers.content = data.customers;
				});
			};
		}else{
			$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
			console.log('CUSTOMER NO WIFI' + JSON.stringify($scope.customers.content));
		};
	};
	var  listExhibitedOffline = {};
	$scope.getListExhibited = function() {
		var checkIn = false;
	if($rootScope.network.status){
		ProductService.getExhibitedDetail($scope.customers.customerId).then(function(data) {
			console.log('exhibited' + JSON.stringify(data));
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
				console.log('log'+ JSON.stringify(data));//xu ly tiep trung bay
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
					console.log('list ex' + JSON.stringify($scope.exhibited.info));
				};
				
			},function(err){
				console.log(JSON.stringify(err));
			});
		};
	};
	$scope.getDataExhibited = function(query){
		return SqlService.query(query).then(function(data){
			console.log('log'+ JSON.stringify(data));
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
		if($rootScope.network.status){
			ProductService.getExhibitedForMark(customerId).then(function(data) {
			if (data.result) {
				for (var rs in data.result) {
					console.log(data.result[rs].productPromoRegisterId);
					$scope.exhibited.list.push({
						promoName : data.result[rs].promoName,
						promoId : data.result[rs].productPromoId,
						ruleId : data.result[rs].productPromoRuleId,
						createdDate : formatDateDMY(data.result[rs].createdDate.time),
						createBy : data.result[rs].createdBy,
						productPromoRegisterId : data.result[rs].productPromoRegisterId
					});
				}
				console.log($scope.exhibited.list);
			}
		});
		}else{
			var query = "SELECT DISTINCT * FROM exhibitedRegister WHERE customerId ='"+customerId+"'";
			SqlService.query(query).then(function(data){
				for(var rs in data){
					$scope.exhibited.list.push({
							promoName : data[rs].promoName,
							promoId : data[rs].productPromoId,
							ruleId : data[rs].ruleId,
							createdDate : data[rs].createdDate,
							productPromoRegisterId : data[rs].productPromoRegisterId
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
			$scope.getExhibitedForMark(currentCustomer.partyIdTo);
			$scope.customers.customerName = currentCustomer.groupName;
		} else
			bootbox.alert("Hãy chọn cửa hàng cần chấm điểm Trưng bày");
	};
	$scope.exhibitedRegister = function() {
		//check in register not same DB
	if($rootScope.network.status){
		$scope.customers.createdDate = getCurrentDateYMD();
		ProductService.exhibitedRegister($scope.customers).then(function(data) {
			if (data.result) {
				bootbox.alert("Đăng ký trưng bày thành công");
			}
		},function(){
				bootbox.alert("Đăng ký trưng bày không thành công");				
		});
	}else {
		var fields = ["customerName","customerId","productPromoId","ruleId","ruleName","quantity","productId","productName","fromDate","thruDate","promoName","createdDate"];
		var tmp = [];
		var input = [];
		$scope.customers.createdDate = getCurrentDateYMD();
		tmp = [$scope.customers.customerName,$scope.customers.customerId,$scope.customers.productPromoId,$scope.customers.ruleId,$scope.customers.ruleName,$scope.customers.quantity,$scope.customers.productId,$scope.customers.productName,$scope.customers.fromDate,$scope.customers.thruDate,$scope.customers.promoName,$scope.customers.createdDate];
		input.push(tmp);
		SqlService.insert('exhibitedRegister',fields,input).then(function(data){
			bootbox.alert("Đăng ký trưng bày thành công");
		},function(err){
			bootbox.alert("Đăng ký trưng bày không thành công");
			console.log('register error');
		});
	}
		

	};
	$scope.sendMark = function() {
		if (!$scope.exhibited.showMark || $scope.infoExhibitedMarks.isSequency.length == 0 || $scope.infoExhibitedMarks.result.length == 0) {
			bootbox.alert("Hãy nhập đủ thông tin (*) để chấm điểm");
		} else if ($scope.infoExhibitedMarks) {
			ProductService.sendMark($scope.infoExhibitedMarks).then(function(data) {
				if (data.res) {
					bootbox.alert("Chấm điểm thành công , chờ phê duyệt");
				} else
					bootbox.alert("Chấm điểm không thành công");
			});
		}

	};
});
