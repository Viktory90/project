var snapper = new Snap({
	element : document.getElementById('wrapper'),
	disable : 'right',
	maxPosition : 400,
	easing : 'linear',
	transitionSpeed : 0.1
});

/*inti function*/
/*"productPromoId", "promoName", "promoText", "productId", "productPromoStatusId", "productPromoTypeId", "showToCustomer", "requireCode", "useLimitPerOrder", "useLimitPerPromotion", "useLimitPerCustomer", "fromDate", "thruDate", "paymentMethod", "productPromoRuleId", "orderAdjustmentTypeId", "productPromoActionEnumId", "operatorEnumId", "productPromoCondSeqId", "productPromoActionSeqId", "productPromoApplEnumId", "ruleName", "inputParamEnumId", "condValue", "partyId", "otherValue", "amount", "notes", "quantity"*/
olbius.run(function($window, $rootScope, $route, $templateCache, $location, $cordovaNetwork , SqlService) {
	$templateCache.put('searchbox.tpl.html', '<input id="pac-input" class="pac-controls" type="text" placeholder="Search">');
	$templateCache.put('window.tpl.html', '<div ng-controller="WindowCtrl" ng-init="showPlaceDetails(parameter)">{{place.name}}</div>');
	$rootScope.$on("$routeChangeSuccess", function(event, current, previous) {
		snapper.close();
		var login = localStorage.getItem("login");
		if (previous && previous.$$route) {
			var back = previous.$$route.originalPath;
			localStorage.setItem("previous", "true");
			if (back == "/main" && current && current.$$route.originalPath == "/login" && login == "true") {
				$location.path("/main");
			}
		}
	});
	$rootScope.network = {
			type: $cordovaNetwork.getNetwork(),
			status: $cordovaNetwork.isOnline()
		};
	$rootScope.$on('$cordovaNetwork:online', function(event, networkState){
		if(networkState !== 'unknown' || networkState !== 'none'){
			$rootScope.network.type = networkState;
			$rootScope.network.status = true;
		};
		console.log('networkStateInit' +' '+ networkState);
		console.log('$rootScope.network.Status'+' '+$rootScope.network.status);
	});	
	$rootScope.$on('$cordovaNetwork:offline', function(event, networkState){
		if(networkState === 'unknown' || networkState === 'none'){
			$rootScope.network.type = networkState;
			$rootScope.network.status = false;
		};
		console.log('networkStateInit' +' '+ networkState);
		console.log('$rootScope.network.Status'+' '+$rootScope.network.status);
	});
	initDB(SqlService);
});
function initDB(SqlService) {
		// var lastPromoId = $.parseJSON(localStorage.getItem("lastPromotionId"));
		// var lastOrderItemId = $.parseJSON(localStorage.getItem("lastOrderItemId"));
		// var lastInventoryId = $.parseJSON(localStorage.getItem("lastInventoryId"));
		// var lastProductId = $.parseJSON(localStorage.getItem("lastProductId"));
			SqlService.getTable("promotions").then(function(res) {
				var fields = res.data;
				SqlService.createTable("promotions", fields).then(function() {
					log("create table promotions success");
				});
			});
			SqlService.getTable("inventories").then(function(res) {
				var fields = res.data;
				SqlService.createTableOrder("inventories", fields).then(function() {
					log("create table inventories success");
				});
			}, function(res) {
				log("error create inventory table ", res);
			});
			
			SqlService.getTable("orderlist").then(function(res) {
				var fields = res.data;
				console.log("orders fields " + JSON.stringify(res));
				SqlService.createTableOrder("orders", fields).then(function() {
					console.log("create table orders success");
				});
			});
			
			SqlService.getTable("products").then(function(res) {
				var fields = res.data;
				SqlService.createTable("products", fields).then(function() {
					log("create table products success");
				});
			});
				
		SqlService.getTable("orderinfo").then(function(res){
			var fields = res.data;
			SqlService.createTable("orderinfo",fields).then(function(){
				log("create table orderinfo success");
			});
		});
		SqlService.getTable("customer").then(function(res){
			var fields = res.data;
			SqlService.createTable("customer",fields).then(function(res){
				log('create Table customer success');
			},function(err){
				log('create table customer error');
			});
		});
		SqlService.getTable("exhibite").then(function(res){
			var fields = res.data;
			SqlService.createTableOrder("exhibite",fields).then(function(res){
				log('create Table exhibite success');
			},function(err){
				log('create table exhibite error');
			});
		});
		SqlService.getTable("exhibitedRegister").then(function(res){
			var fields = res.data;
			SqlService.createTableOrder("exhibitedRegister",fields).then(function(res){
				log('create Table exhibitedRegister success');
			},function(err){
				log('create table exhibitedRegister error');
			});
		});
		SqlService.getTable("customerOpinion").then(function(res){
			var fields = res.data;
			SqlService.createTableOrder("customerOpinion",fields).then(function(res){
				log('create Table customerOpinion success');
			},function(err){
				log('create table customerOpinion error');
			});
		});
		SqlService.getTable("opponent").then(function(res){
			var fields = res.data;
			SqlService.createTableOrder("opponent",fields).then(function(res){
				log('create Table opponent success');
			},function(err){
				log('create table opponent error');
			});
		});
	};
olbius.controller('WindowCtrl', function($scope) {
	$scope.place = {};
	$scope.showPlaceDetails = function(param) {
		$scope.place = param;
	};
});
