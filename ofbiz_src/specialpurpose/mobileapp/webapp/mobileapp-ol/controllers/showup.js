/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ShowupController', function($rootScope, $scope, $controller,ProductService ,CustomerService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.$on('$viewContentLoaded',function(){
		$scope.setHeader("Trưng bày", "/sale", false);
		$scope.inIt();
	});
	$scope.inIt = function(){
		$scope.getAllStore();
	};
	$scope.customers = {
			customerName : "",
			customerId :"",
			productPromoId : "",
			ruleId : "",
			ruleName: "",
			quantity : "",
			productId : "",
			productName : "",
			fromDate : "",
			thruDate : "",
			promoName : ""
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
	$scope.$watch('infoExhibitedMarks.promoRegisterId',function(){
		if($scope.infoExhibitedMarks.promoRegisterId){
			$scope.exhibited.showMark = true;
			console.log($scope.infoExhibitedMarks.promoRegisterId);
			for(var item in  $scope.exhibited.list){
				if($scope.infoExhibitedMarks.promoRegisterId == $scope.exhibited.list[item].productPromoRegisterId){
					$scope.infoExhibitedMarks.promoName = $scope.exhibited.list[item].promoName;
					$scope.infoExhibitedMarks.promoId = $scope.exhibited.list[item].promoId;
					$scope.infoExhibitedMarks.ruleId = $scope.exhibited.list[item].ruleId;
					$scope.infoExhibitedMarks.createdDate = $scope.exhibited.list[item].createdDate;
					$scope.infoExhibitedMarks.createdBy = $scope.exhibited.list[item].createBy;
				}
			};
			console.log($scope.infoExhibitedMarks);
		}else $scope.exhibited.showMark = false;
	});
	$scope.$watch('customers.customerId',function(){
		console.log($scope.customers.customerId);
		$scope.exhibited.info = new Array();//clear Array empty when call Ajax
		if($scope.customers.customerId){
			$scope.getListExhibited();
			$scope.exhibited.showExhibited = true;
		}else $scope.exhibited.showExhibited = false;
	});
	$scope.$watch('customers.productPromoId',function(){
		$scope.exhibited.rule = new Array();
	if($scope.customers.productPromoId)	{
			$scope.exhibited.showRule = true;
		for(var key in $scope.exhibited.content){
			if($scope.customers.productPromoId ==  $scope.exhibited.content[key].productPromoId){
				$scope.exhibited.rule.push({
					ruleId : $scope.exhibited.content[key].productPromoRuleId,
				});
			}
		}
	}else $scope.exhibited.showRule = false;
	});
	$scope.$watch('customers.ruleId',function(){
		if($scope.customers.ruleId){
			$scope.exhibited.showDetail = true;
			for(var key in  $scope.exhibited.content){
				if($scope.customers.ruleId == $scope.exhibited.content[key].productPromoRuleId){
					$scope.customers.ruleName = $scope.exhibited.content[key].ruleName;
					$scope.customers.productId = $scope.exhibited.content[key].productId;
					$scope.customers.productName = $scope.exhibited.content[key].productName;
					$scope.customers.quantity = $scope.exhibited.content[key].quantity;
					$scope.customers.fromDate = formatDateDMY($scope.exhibited.content[key].fromDate.time);
					$scope.customers.thruDate = formatDateDMY($scope.exhibited.content[key].thruDate.time);
					$scope.customers.productPromoTypeId = $scope.exhibited.content[key].productPromoTypeId;
					$scope.customers.promoName = $scope.exhibited.content[key].promoName;
				}
			}
		}else $scope.exhibited.showDetail = false;
	});
	$scope.getAllStore = function(){
		CustomerService.getAll(0,100,null).then(function(data){
			$scope.customers.content = data.customers;
			var currentCustomer = localStorage.getItem('currentCustomer');
			var flag = false;
			if(currentCustomer){
				for(var cus in data.customers){
					if(cus.partyIdTo == currentCustomer.partyIdTo){
						flag = true;
					}
				}
			}
			if(flag){
				
			}
			var objTmp = {
				'partyIdTo' : '10000',
				'groupName' : 'Test' 				
			};
			$scope.customers.content.splice(0,0,objTmp);
		});
	};
	var checkIn = false;
	$scope.getListExhibited = function(){
		ProductService.getExhibitedDetail($scope.customers.customerId).then(function(data){
			$scope.exhibited.content = data.listExhibited;
			for(var ex in $scope.exhibited.content){
				var  arr = $scope.exhibited.info;
				if(arr.length > 0){
					for(var i in arr){
						if(arr[i].productPromoId == $scope.exhibited.content[ex].productPromoId){
							checkIn = true;
						}else checkIn = false;
					}
					if(!checkIn){
						arr.push({
							productPromoId : $scope.exhibited.content[ex].productPromoId,
							promoName : $scope.exhibited.content[ex].promoName,
						});
					}
				}else {
					arr.push({
						productPromoId : $scope.exhibited.content[ex].productPromoId,
						promoName : $scope.exhibited.content[ex].promoName,
					});
				}
			}
			$scope.exhibited.info  = arr;
		});
	};
	$scope.changeTab1 = function(){
		$('#list1').addClass('active');
		$('#ExhibitedRegister').addClass('active');
		$('#list2').removeClass('active');
		$('#MarksExhibited').removeClass('active');
	};
	$scope.getExhibitedForMark = function(customerId){
		ProductService.getExhibitedForMark(customerId).then(function(data){
			console.log(data);
			if(data.result){
				for(var rs in data.result){
					console.log(data.result[rs].productPromoRegisterId);
				$scope.exhibited.list.push({
					promoName : data.result[rs].promoName,
					promoId : 	data.result[rs].productPromoId,
					ruleId : data.result[rs].productPromoRuleId,
					createdDate :  formatDateDMY(data.result[rs].createdDate.time),
					createBy : 	data.result[rs].createdBy,
					productPromoRegisterId : data.result[rs].productPromoRegisterId
				});
			}
			}
		});
	};
	function formatDateDMY(date) {
		var today = new Date(date);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		// January is 0!

		var yyyy = today.getFullYear();
		if (dd < 10) {
			dd = '0' + dd;
		}
		if (mm < 10) {
			mm = '0' + mm;
		}
		today = dd + '-' + mm + '-' + yyyy;
		return today;
	}
	var currentCustomer = {};
	$scope.changeTab2 = function(){
		$('#list2').addClass('active');
		$('#MarksExhibited').addClass('active');
		$('#list1').removeClass('active');
		$('#ExhibitedRegister').removeClass('active');
		currentCustomer = $.parseJSON(localStorage.getItem("currentCustomer"));
		if(typeof currentCustomer != 'undefined' && Object.keys(currentCustomer).length !== 0){
			$scope.exhibited.list = new Array();
			$scope.getExhibitedForMark(currentCustomer.partyIdTo);
			$scope.customers.customerName = currentCustomer.groupName;
		}else bootbox.alert("Hãy chọn cửa hàng cần chấm điểm Trưng bày");
	};
	var infoRegister = new Array();
	$scope.exhibitedRegister = function(){
		//check in register not same DB
//	if(localStorage.getItem('infoRegister'))
//		{
//			for(var key in infoRegister){
//				console.log('test',infoRegister);
//				if(infoRegister[key].productPromoId == $scope.customers.productPromoId 
//						&& infoRegister[key].ruleId == $scope.customers.ruleId 
//						&& infoRegister[key].customerId == $scope.customers.customerId){
//							bootbox.alert("Đã tồn tại chương trình trưng bày này tại cửa hàng");
//						break;
//					}else {
						ProductService.exhibitedRegister($scope.customers).then(function(data){
							if(data.result){
								console.log(data.result);
								bootbox.alert("Đăng ký trưng bày thành công");
							}
						});
//					}
				
//			}
//		}else {
//			if(infoRegister.length == 0){
//				infoRegister.push($scope.customers);
//				ProductService.exhibitedRegister($scope.customers).then(function(data){
//					if(data.result){
//						console.log(data.result);
//						bootbox.alert("Đăng ký trưng bày thành công");
//					}
//				});
//			}
//			
//		}
		
	};
	$scope.sendMark = function(){
		if(!$scope.exhibited.showMark || $scope.infoExhibitedMarks.isSequency.length == 0 ||$scope.infoExhibitedMarks.result.length ==0 ){
			bootbox.alert("Hãy nhập đủ thông tin (*) để chấm điểm");
		}else if($scope.infoExhibitedMarks){
//			if(localStorage.getItem('infoExhibited')){
//				var temp = $.parseJSON(localStorage.getItem('infoExhibited'));
//				for(var key in tmp){
//					if($scope.infoExhibitedMarks.promoId == tmp[key].promoId && $scope.customersId == currentCustomer.partyIdTo){
//						
//						
//					}
//				}
//			}else localStorage.setItem('infoExhibited',$scope.infoExhibitedMarks);
			ProductService.sendMark($scope.infoExhibitedMarks).then(function(data){
				if(data.res){
					bootbox.alert("Chấm điểm thành công , chờ phê duyệt");
				}else bootbox.alert("Chấm điểm không thành công");
			});
			}	
		
	};
});
