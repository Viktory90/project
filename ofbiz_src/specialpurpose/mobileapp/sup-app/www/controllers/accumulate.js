/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('AccumulateController', function($rootScope, $scope, $controller, ProductService ,CustomerService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.customers = {
			partyId : "",
	};
	$scope.check = true;
	$scope.$on('$viewContentLoaded',function(){
		$scope.setHeader("Chương trình tích lũy", "/sale", false);	
		$scope.inIt();
	});
	$scope.$watch('customers.partyId',function(){
		if($scope.customers.partyId){
			$scope.check = false;
			$scope.getAccumulateStore();
		}else $scope.check = true;
	});
	$scope.index = {};
	$scope.$watch('listAccumulate.productPromoId',function(){
		$scope.listAccumulate.listRule = new Array();
		for(var x in $scope.listAccumulate.content){
			var objTmp = {};
			objTmp = {
					ruleName : $scope.listAccumulate.content[x].productPromoRuleId,
					ruleId : $scope.listAccumulate.content[x].productPromoRuleId					
			};
			console.log('listRue' + JSON.stringify(objTmp));
			$scope.listAccumulate.listRule.push(
				objTmp
			);
		};
		console.log('listRule : ' + JSON.stringify($scope.listAccumulate.listRule));
	});
	$scope.$watch('listAccumulate.ruleId',function(){
		for(var x in $scope.listAccumulate.content){	
			if($scope.listAccumulate.ruleId == $scope.listAccumulate.content[x].productPromoRuleId){
					$scope.index =  $scope.listAccumulate.content[x];
					$scope.index.customerId = $scope.customers.partyId;
				}
		};
	});
	$scope.inIt = function(){
		$scope.getAllStore();
	};
	$scope.listAccumulate = {
			productPromoId : "",
			ruleId : "",
			listRule : [],
			content : ""
	};
	$scope.getAccumulateStore = function(){
		var currentCustomer  = $.parseJSON(localStorage.getItem("currentCustomer"));
			ProductService.getAccumulateStore($scope.customers.partyId).then(function(data){
				$scope.listAccumulate.content = data.listAccumulate ;
			});
	};
	$scope.getAllStore = function(){
		if(localStorage.getItem('listStore')){
			$scope.customers = localStorage.getItem('listStore');
		}else {
			CustomerService.getAll(0,100,null).then(function(data){
			$scope.customers= data.customers;
		});
		}
	};
	$scope.accumulateRegister = function(){
		if($scope.index){
		ProductService.accumulateRegister($scope.index).then(function(data){
			if(data.accumulate){
				bootbox.alert("Đăng ký chương trình tích lũy thành công");
				
			}else bootbox.alert("Đăng ký chương trình tích lũy không thành công");
		});
		}
	};
});
