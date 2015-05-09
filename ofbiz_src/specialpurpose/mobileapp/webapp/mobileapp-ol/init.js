var snapper = new Snap({
	element : document.getElementById('wrapper'),
	disable : 'right',
	maxPosition : 400,
	easing : 'linear',
	transitionSpeed : 0.1
});

/*inti function*/
/*"productPromoId", "promoName", "promoText", "productId", "productPromoStatusId", "productPromoTypeId", "showToCustomer", "requireCode", "useLimitPerOrder", "useLimitPerPromotion", "useLimitPerCustomer", "fromDate", "thruDate", "paymentMethod", "productPromoRuleId", "orderAdjustmentTypeId", "productPromoActionEnumId", "operatorEnumId", "productPromoCondSeqId", "productPromoActionSeqId", "productPromoApplEnumId", "ruleName", "inputParamEnumId", "condValue", "partyId", "otherValue", "amount", "notes", "quantity"*/
olbius.run(function($window, $rootScope, $route, $templateCache, $location) {
	$templateCache.put('searchbox.tpl.html', '<input id="pac-input" class="pac-controls" type="text" placeholder="Search">');
	$templateCache.put('window.tpl.html', '<div ng-controller="WindowCtrl" ng-init="showPlaceDetails(parameter)">{{place.name}}</div>');
	$rootScope.$on("$routeChangeSuccess", function(event, current, previous) {
		$('.main-container').removeClass('main-bg');
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
	$rootScope.openDialog = function(str1,str2){
		BootstrapDialog.show({
								title : 'Thông Báo',
					            message: str1,
					            type : BootstrapDialog.TYPE_SUCCESS,
					            closable : true,
					            spinicon : 'fa fa-spinner',
					            buttons: [{
					                icon: 'glyphicon glyphicon-ok',
					                label: 'Chấp nhận',
					                cssClass: 'btn-primary',
					                autospin: true,
					                action: function(dialogRef){
					                    dialogRef.enableButtons(false);
					                    dialogRef.setClosable(false);
					                    if(str2){
					                    	dialogRef.getModalBody().html(str2);	
					                    }
					                    setTimeout(function(){
					                        dialogRef.close();
					                    }, 300);
					                }
					            }]
					        }); 
	};
	
});

olbius.controller('WindowCtrl', function($scope) {
	$scope.place = {};
	$scope.showPlaceDetails = function(param) {
		$scope.place = param;
	};
});
