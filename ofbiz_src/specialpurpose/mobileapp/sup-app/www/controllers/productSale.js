/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ProductSaleController', function($rootScope, $scope, $controller,ProductService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	
	$scope.$on('$viewContentLoaded',function(){
		$scope.setHeader("Khuyến mại theo đơn", "/sale", false);	
		$scope.inIt();
	});
	$scope.inIt = function(){
		$scope.getListPromotions();
	};
	$scope.checkRequest = false;
	$scope.listPromotions = new Array();
	$scope.getListPromotions = function(){
		var currentCustomer =  $.parseJSON(localStorage.getItem('currentCustomer'));
		if(typeof currentCustomer != 'undefined'){
			if($rootScope.network.status){
					ProductService.getListPromotions(currentCustomer.partyIdTo).then(function(data){
					console.log(data);
					for(var x in data.listPromoEvent){
						$scope.listPromotions .push ({
								promoName : data.listPromoEvent[x].promoName,
								ruleName : data.listPromoEvent[x].ruleName,
								fromDate : data.listPromoEvent[x].fromDate,
								thruDate : data.listPromoEvent[x].thruDate,
							});
					}
					console.log('pro',$scope.listPromotions);
				});
			}else{
				var listPromotionsOffline = {};
				var query = "SELECT * FROM promotions";
				SqlService.query(query).then(function(data){
					listPromotionsOffline = data;
					if(listPromotionsOffline){
						for(var x in listPromotionsOffline){
							if($scope.listPromotions && $scope.listPromotions.length > 0){
								for(var pro in $scope.listPromotions){
									if($scope.listPromotions[pro].productPromoId == listPromotionsOffline[x].productPromoId){
										continue;
									}else {
										$scope.listPromotions.push({
											promoName : listPromotionsOffline[x].promoName,
											ruleName : listPromotionsOffline[x].ruleName,
											fromDate : listPromotionsOffline[x].fromDate,
											thruDate : listPromotionsOffline[x].thruDate									
										});									
									};
								};
							}else {
								$scope.listPromotions.push({
								promoName : listPromotionsOffline[x].promoName,
								ruleName : listPromotionsOffline[x].ruleName,
								fromDate : listPromotionsOffline[x].fromDate,
								thruDate : listPromotionsOffline[x].thruDate									
							});
							};
							
						};
					};
				},function(err){
					console.log('get list promotions offline failed');
				});
			};
		}else bootbox.alert("Chưa chọn cửa hàng kiểm tồn");
	};
	
});
