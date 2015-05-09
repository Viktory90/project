/*global todomvc, angular */

'use strict';
/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('BaseController', function($rootScope, $scope, CustomerService) {
	$rootScope.isHeader = true;
	$rootScope.isMain = false;
	/* get back previous */
	$rootScope.previous = "/main";
	//$rootScope.isFilterable = false;
	//$rootScope.isOffline = false;
	/*keyword search*/
	//$scope.keyword = "";
	/* default title */
	$rootScope.headerTitle = "Salesman Delys";
	$rootScope.loading = angular.element(document.querySelectorAll('#loading'));
	$scope.body = angular.element($('body'));
	$scope.html = angular.element($('html'));
	$scope.wrapper = angular.element($('#wrapper'));
	$scope.issidebar = false;
	$rootScope.showLoading = function() {
		$scope.disableScroll();
		window.scrollTo(0, 0);
		$rootScope.loading.css('display', 'block');
	};
	$rootScope.hideLoading = function() {
		$scope.enableScroll();
		$rootScope.loading.css('display', 'none');
	};

	/*get all customer of salesman & save to localStorage*/
	$scope.getStore = function() {
		var customers = localStorage.getItem("customers");
		if (customers) {
			$scope.customers = JSON.parse(customers);
		} else {
			CustomerService.getStoreByRoad().then(function(res) {
				$scope.customers.content = res.customers;
				$scope.customers.total = res.total;
				$scope.customers.size = res.size;
				$scope.customers.road = res.road;
				if($scope.customers.content && $scope.customers.content.length){
					localStorage.setItem("customers", JSON.stringify($scope.customers));
				}
			});
		}
	};
		//config Language
	$rootScope.key = localStorage.getItem('currentLanguage') ? localStorage.getItem('currentLanguage') : "vi";
	$rootScope.ChangeEnglish = function(){
		$rootScope.key = 'en';
		localStorage.setItem('currentLanguage','en');
	};
	$rootScope.ChangeTV = function(){
		$rootScope.key = 'vi';
		localStorage.setItem('currentLanguage','vi');
	};
	
	$scope.initScreen = function() {
		console.log('key' + $rootScope.key);
		$('.main-container').removeClass('main-bg');
		//$scope.hideSidebar();
		//$scope.body.css('min-height', $(document).height());
		//$scope.wrapper.css('min-height', $(document).height());
		$('.fullscreen').css('height', $(document).height());
		$('.fullscreen').css('max-width', $(document).width());
	};
	$scope.disableScrollX = function() {
		$scope.body.css('overflow-x', 'hidden');
	};
	$scope.enableScrollX = function() {
		$scope.body.css('overflow-x', '');
	};
	$scope.disableScrollY = function() {
		$scope.body.css('overflow-y', 'hidden');
	};
	$scope.enableScrollY = function() {
		$scope.body.css('overflow-y', '');
	};
	$scope.disableScroll = function() {
		var obj = {
			'overflow' : 'hidden',
			'height': '100%'
		};
		$("#wrapper").css(obj);		
		$scope.body.css(obj);
		$scope.html.css(obj);
	};
	$scope.enableScroll = function() {
		var obj = {
			'overflow' : '',
			'height': ''
		};
		$scope.body.css(obj);
		$scope.html.css(obj);
	};
	$scope.disableScroll();
	$scope.setHeader = function(header, back, isLogo) {
		console.log(header);
		$rootScope.headerTitle = header;
		$rootScope.previous = back;
		$rootScope.showLogo = isLogo;
	};

	/* display notification after an ajax .... */
	$scope.showNotification = function(status, notification) {
		$scope.notification = notification;
		if (!status) {
			$("#notification").addClass("error");
		} else {
			$("#notification").removeClass("error");
		}
		$("#notification").show();
		var time = setTimeout(function() {
			$("#notification").hide();
			clearTimeout(time);
		}, 1000);
	};
	$scope.FormatNumberBy3 = function(num, decpoint, sep) {
		if(num){
			// check for missing parameters and use defaults if so
		
			if (arguments.length == 2) {
				sep = ",";
			}
			if (arguments.length == 1) {
				sep = ",";
				decpoint = ".";
			}
			// need a string for operations
			var num = num.toString();
			// separate the whole number and the fraction if possible
			var a = num.split(decpoint);
			var x = a[0];
			// decimal
			var y = a[1];
			// fraction
			var z = "";

			if ( typeof (x) != "undefined") {
				// reverse the digits. regexp works from left to right.
				for (var i = x.length - 1; i >= 0; i--)
					z += x.charAt(i);
				// add seperators. but undo the trailing one, if there
				z = z.replace(/(\d{3})/g, "$1" + sep);
				if (z.slice(-sep.length) == sep)
					z = z.slice(0, -sep.length);
				x = "";
				// reverse again to get back the number
				for (var i = z.length - 1; i >= 0; i--)
					x += z.charAt(i);
				// add the fraction back in, if it was there
				if ( typeof (y) != "undefined" && y.length > 0)
					x += decpoint + y;
			}
			return x;

		}
		
	};
	$scope.initScreen();
});
