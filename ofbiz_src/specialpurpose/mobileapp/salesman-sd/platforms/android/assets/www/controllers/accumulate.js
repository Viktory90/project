/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('AccumulateController', function($rootScope,$route, $scope, $controller, ProductService ,CustomerService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.customers = {
			partyId : "",
	};
	$scope.check = true;
	$scope.$on('$viewContentLoaded',function(){
		$scope.setHeader('Accumulate', "/sale", false);	
		$scope.inIt();
	});
	$scope.cancel = function(){
		$route.reload();
	};
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
			$scope.listAccumulate.listRule.push(
				objTmp
			);
		};
	});
	$scope.$watch('listAccumulate.ruleId',function(){
		for(var x in $scope.listAccumulate.content){	
			if($scope.listAccumulate.ruleId == $scope.listAccumulate.content[x].productPromoRuleId){
					$scope.index =  $scope.listAccumulate.content[x];
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
		if($rootScope.network.status){
			ProductService.getAccumulateStore($scope.customers.partyId).then(function(data){
				$scope.listAccumulate.content = data.listAccumulate ;
			});
		}else {
			var query = "SELECT * FROM accumulate";
			SqlService.query(query).then(function(data){
				$scope.listAccumulate.content = data;
				console.log('tatat'+ JSON.stringify($scope.listAccumulate.content));
			},function(err){
				console.log('error get data accumulate from SQLite');
			});
		}
	};
	$scope.getAllStore = function(){
		if($rootScope.network.status){
			if(localStorage.getItem('listStore')){
				$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
			}else {
				CustomerService.getStoreByRoad(0, 100,'N',null).then(function(data) {
					$scope.customers.content = data.customers;
				});
			};
		}else{
			$scope.customers.content = $.parseJSON(localStorage.getItem('listStore'));
		};		
	};
	$scope.accumulateRegister = function(){
		$rootScope.showLoading();
		if($scope.index){
			if($rootScope.network.status){
					$scope.index.customerId = $scope.customers.partyId;
					var createdDate = getCurrentDateYMD();
					$scope.index.createdDate = createdDate;
				ProductService.accumulateRegister($scope.index).then(function(data){
					$rootScope.hideLoading();
					if(data.accumulate){
						if(data.accumulate.duplicate){
							$rootScope.openDialog($rootScope.Map.NotiAccumulateDuplicate[$rootScope.key]);
						}else $rootScope.openDialog($rootScope.Map.RegisterAccSuccess[$rootScope.key]);
					}else $rootScope.openDialog($rootScope.Map.RegisterAccError[$rootScope.key]); 
				});
			}else{
				$scope.index.customerId = $scope.customers.partyId;
				var input = [];
				var fields = ['customerId','productPromoId','productPromoRuleId','createdDate'];
				var createDate = getCurrentDateYMD();
				var tmp = [$scope.index.customerId,$scope.index.productPromoId,$scope.index.productPromoRuleId,createDate];
				input.push(tmp);
				$rootScope.hideLoading();
				SqlService.insert('accumulateRegister',fields,input).then(function(data){
					if(data){
						$rootScope.openDialog($rootScope.Map.RegisterAccSuccess[$rootScope.key]);
					}else $rootScope.openDialog($rootScope.Map.RegisterAccError[$rootScope.key]); 
				},function(err){
					$rootScope.openDialog($rootScope.Map.RegisterAccSuccess[$rootScope.key]);
				});
			}	
		}
	};
});
