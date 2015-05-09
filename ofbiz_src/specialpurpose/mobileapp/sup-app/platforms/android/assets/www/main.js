'use strict';
if (!localStorage.serverUrl) {
	// localStorage.serverUrl = 'https://192.168.124.69:8443/mobileservices/control/';
	localStorage.serverUrl = 'https://192.168.72.1:8443/mobileservices/control/';
}
var baseUrl = localStorage.serverUrl;
var config = {
	pageSize : 30,
	distance : 100
};

var db = ['inventories', 'orders', 'promotions', "products","orderinfo"];
var olbius = angular.module('olbius', ['ngCordova', 'ngRoute', "uiGmapgoogle-maps","highcharts-ng"]);
olbius.config(['$routeProvider', 'uiGmapGoogleMapApiProvider',
function olbiusConfig($routeProvider, GoogleMapApi) {
	GoogleMapApi.configure({
		v : '3.17',
		libraries : 'places'
	});

	$routeProvider.when('/', {
		controller : 'IndexController',
		templateUrl : 'templates/index.htm',
	}).when('/login', {
		templateUrl : 'templates/login.htm',
		controller : 'LoginController'
	}).when('/store', {
		templateUrl : 'templates/store.htm',
		controller : 'StoreController'
	}).when('/main', {
		templateUrl : 'templates/main.htm',
		controller : 'MainController'
	}).when('/order/create', {
		templateUrl : 'templates/createOrder.htm',
		controller : 'CreateOrderController'
	}).when('/customer', {
		templateUrl : 'templates/customer.htm',
		controller : 'CustomerController'
	}).when('/customer/create', {
		templateUrl : 'templates/createCustomer.htm',
		controller : 'CreateCustomerController'
	}).when('/customer/detail/:id', {
		templateUrl : 'templates/customerDetail.htm',
		controller : 'CustomerDetailController'
	}).when('/order/:iscurrent', {
		templateUrl : 'templates/order.htm',
		controller : 'OrderController'
	}).when('/order/detail/:id', {
		templateUrl : 'templates/orderDetail.htm',
		controller : 'OrderDetailController'
	}).when('/sale/showup', {
		templateUrl : 'templates/showup.htm',
		controller : 'ShowupController'
	}).when('/sale/product-sale', {
		templateUrl : 'templates/productSale.htm',
		controller : 'ProductSaleController'
	}).when('/sale/accumulate', {
		templateUrl : 'templates/accumulate.htm',
		controller : 'AccumulateController'
	}).when('/sale', {
		templateUrl : 'templates/sale.htm',
		controller : 'SaleController'
	}).when('/inventory', {
		templateUrl : 'templates/inventory.htm',
		controller : 'InventoryController'
	}).when('/inventory/:isFinish', {
		templateUrl : 'templates/inventory.htm',
		controller : 'InventoryController'
	}).when('/product', {
		templateUrl : 'templates/product.htm',
		controller : 'ProductController'
	}).when('/portal', {
		templateUrl : 'templates/portal.htm',
		controller : 'PortalController'
	}).when('/calendar', {
		templateUrl : 'templates/calendar.htm',
		controller : 'CalendarController'
	}).when('/customer-opinion', {
		templateUrl : 'templates/customerOpinion.htm',
		controller : 'CustomerOpinionController'
	}).when('/dashboard', {
		templateUrl : 'templates/dashboard.htm',
		controller : 'DashboardController'
	}).when('/sync', {
		templateUrl : 'templates/synchronize.htm',
		controller : 'SynchronizeController'
	}).when('/employee-leave', {
		templateUrl : 'templates/employeeLeave.htm',
		controller : 'EmployeeLeaveController'
	}).when('/employee-leave/report', {
		templateUrl : 'templates/employeeLeaveReport.htm',
		controller : 'EmployeeLeaveReportController'
	}).when('/profile', {
		templateUrl : 'templates/profile.htm',
		controller : 'ProfileController'
	}).when('/location', {
		templateUrl : 'templates/location.htm',
		controller : 'LocationController'
	}).when('/markExhibitedSup', {
		templateUrl : 'templates/markExhibitedSup.htm',
		controller : 'MarkExhibitedSupController'
	}).when('/route',{
		templateUrl : 'templates/route.htm',	
		controller : 'routeController'	
	}).otherwise({
		redirectTo : '/login'
	});
	// $locationProvider.html5Mode(true);
}]);
