/*
 * login service
 */
olbius.factory('AuthService', function($http, $location) {
	var authService = {};
	authService.login = function(credentials) {
		return $http({
			url : baseUrl + 'login',
			dataType : "json",
			method : "POST",
			data : $.param(credentials),
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	authService.loginSup = function(credentials,beforeSend) {
		var dt = {
			credentials : JSON.stringify(credentials)
		};
		console.log(JSON.stringify(dt)+ '1111');
		return $http({
			url : baseUrl + 'loginSup',
			dataType : "json",
			method : "POST",
			data : dt,
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	authService.checkLogin = function() {
		return $http.post(baseUrl + 'checkLogin').then(function(res) {
			return res.data.login;
		});
	};
	authService.updatePasswordSalesMan = function(data,beforeSend){
		return $http({
			url : baseUrl + 'updatePasswordSalesMan',
			dataType : "json",
			method : "POST",
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			data : data,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	authService.logout = function() {
		return $http.post(baseUrl + 'logout').then(function(res) {
			if (res.statusText == "OK") {
				localStorage.setItem("login", "false");
			}
		});
	};
	return authService;
});
olbius.factory('LoadRoadService', function($http, $location) {
	var srv = {};
	srv.getRoad = function() {
		return $http.get(baseUrl + 'getSalesmanRoads').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	// get store by road id
	srv.getStoreByRoad = function(id, page, size, beforeSend) {
		return $http({
			url : baseUrl + 'getStoreByRoad',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : {
				id : id,
				viewIndex : page,
				viewSize : size
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};

	return srv;
});
olbius.factory('CustomerService', function($http, $location) {
	var srv = {};
	srv.getTable = function() {
		return $http.get('table/customer.json').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.get = function(id, beforeSend) {
		return $http({
			url : baseUrl + 'customerInfoDetail',
			dataType : "json",
			method : "POST",
			data : {
				customerId : id
			},
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	// get store by road id
	srv.getAll = function(page, size, beforeSend) {
		var data = {};
		if (page && size) {
			data = {
				viewIndex : page,
				viewSize : size
			};
		}
		return $http({
			url : baseUrl + 'getAllStore',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : data,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getStoreByRoad = function(page, size, isGetInventory , beforeSend) {
		console.log('iii' + page + size + isGetInventory);
		var data = {};
			data = {
				isGetInventory : isGetInventory,
				viewIndex : page,
				viewSize : size
			};
		return $http({
			url : baseUrl + 'getStoreByRoad1',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : data,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.createCustomer = function(beforeSend, customer) {
		console.log(customer.startDate,customer.birthDay);
		return $http({
//			url : baseUrl + 'createNewCustomer',
			url : baseUrl + 'createCustomerSalesMan',
			method : "POST",
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			data : customer,
			dataType : "json",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getTotalOrderDetail = function(customerId,month){
			return $http({
				url : baseUrl + 'getDetailTotalOrder',
				transformRequest : function(obj) {
					return transformRequest(obj);
				},
				dataType : "json",
				method : "POST",
				data : {
					customerId : customerId,
					month : month
				},
				headers :  {
					'Content-Type' : 'application/x-www-form-urlencoded' 
				}
			}).then(function(res){
				checkLogin(res.data,$location);
				return res.data;
			});
		};
	srv.getOrderProductDetailOfCustomer = function(customerId,month){
		return $http({
			url : baseUrl + 'getOrderProductDetailOfCustomer',
			transformRequest : function(obj){
				return transformRequest(obj);
			},
			method : "POST",
			dataType : "json",
			data : {
				partyId : customerId,
				month : month
			},
			headers : {
				'Content-Type'  : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
		
	};
	srv.updateLocationCustomer = function(customerId,latitude,longitude){
		console.log(latitude);
		return $http({
			url : baseUrl + 'updateLocationCustomer',
			transformRequest : function(obj){
				return transformRequest(obj);
			},
			method : "POST",
			dataType : "json",
			data : {
				customerId : customerId,
				latitude : latitude ,
				longitude : longitude
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	}
	srv.updateCustomerName = function(partyId,groupName){
		return $http({
			url : baseUrl + 'updateCustomer',
			transformRequest : function(obj){
				return transformRequest(obj);
			},
			method : "POST",
			dataType : "json",
			data : {
				partyId: partyId,
				groupName : groupName
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data);
			return res.data;
		});
		
		
	}
	return srv;
});
olbius.factory('OrderService', function($http, $location) {
	var srv = {};
	/* get order (create new order) information table format */
	srv.getTable = function() {
		return $http.get('table/order.json').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	/* get orders (list ordered) information table format */
	srv.getTableList = function() {// list all order
		return $http.get('table/orders.json').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	/* get orders */
	srv.getList = function(beforeSend, page, size) {
		return $http({
			url : baseUrl + 'orderHeaderListView',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			cache : true,
			data : {
				viewIndex : page,
				viewSize : size,
				// current : iscurrent
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			console.log(res);
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	/* get order's detail information */
	srv.getOrderDetail = function(beforeSend, id) {
		return $http({
			url : baseUrl + 'getOrderDetail',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			cache : true,
			data : {
				id : id
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.submitOrder = function(customerId, products, beforeSend) {
		return $http({
			url : baseUrl + 'submitOrder',
			method : "POST",
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			data : {
				customerId : customerId,
				products : products
			},
			dataType : "json",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	return srv;
});
olbius.factory('CategoryService', function($http, $location) {
	var srv = {};
	srv.getAll = function(beforeSend) {
		return $http.get(baseUrl + 'getAllCategories', {
			transformRequest : function(obj) {
				transformRequest(obj, beforeSend);
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	return srv;
});
olbius.factory('WorkService', function($http, $location) {
	var srv = {};
	srv.updateWorkEffort = function() {
		return $http.post(baseUrl + 'updateWorkEffort', {
			partyId : partyId,
			workEffortId : event._id,
			workEffortName : event.title,
			description : event.title,
			workEffortTypeId : 'AVAILABLE',
			currentStatusId : 'CAL_TENTATIVE',
			scopeEnumId : 'WES_PRIVATE',
			estimatedStartDate : startDate,
			estimatedCompletionDate : endDate,
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	return srv;
});
olbius.factory('ProductService', function($http, $location) {
	var srv = {};
	srv.getTable = function() {
		return $http.get('table/product.json').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	// get product by category
	srv.getByCategory = function(id, page, size, beforeSend) {
		return $http({
			url : baseUrl + 'getProductOfCat',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : {
				productCategoryId : id,
				viewIndex : page,
				viewSize : size
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	// get List Marked By SalesMan
	srv.getListMarkedBySalesMan = function(beforeSend) {
		return $http({
			url : baseUrl + 'getListMarkedBySalesMan',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	// get new product
	srv.getNewProduct = function(beforeSend) {
		return $http.post(baseUrl + 'getNewProducts', {
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getAll = function(beforeSend) {
		return $http.post(baseUrl + 'getAllProducts', {
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getListPromotions = function(partyId,beforeSend){
		return $http({
			url : baseUrl + 'getListPromotionsEvent',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			data : {
				partyId : partyId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	srv.getAccumulateStore = function(partyId,beforeSend){
		return $http({
			url: baseUrl + 'getAccumulateStore',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			data : {
				partyId : partyId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	srv.accumulateRegister = function(info,beforeSend){
		return $http({
			url : baseUrl + 'accumulateRegister',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			data : info,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	srv.getExhibitedDetail = function(partyId,beforeSend){
		return $http({
			url : baseUrl + 'getExhibitedDetail',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			data : {
				partyId : partyId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data);
			return res.data;
		});
	};
	srv.exhibitedRegister = function(customers,beforeSend){
		return $http({
			url : baseUrl + 'exhibitedRegister',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			data : customers,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data);
			return res.data;
		})
	};
	srv.getExhibitedForMark = function(customerId,beforeSend){
		return $http({
			url : baseUrl + 'getExhibitedForMark',
			dataType : "json",
			method : "POST",
			transformRequest : function(obj) {
				return transformRequest(obj,beforeSend);
			},
			data : {
				customerId : customerId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data);
			return res.data;
		});
	};
	srv.sendMark = function(data,beforeSend){
		return $http({
			url : baseUrl + 'sendMark',
			dataType : "json",
			method : "POST",
			transformRequest : function(obj) {
				return transformRequest(obj,beforeSend);
			},
			data : data,
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data);
			return res.data;
		});
	};
	return srv;
});
// all service for employee
olbius.factory('EmployeeService', function($http, $location) {
	var srv = {};
	srv.getType = function(beforeSend) {
		return $http.post(baseUrl + 'employeeLeaveType', {
			transformRequest : beforeSend
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getReason = function(beforeSend) {
		return $http.post(baseUrl + 'employeeLeaveReason', {
			transformRequest : beforeSend
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getHistory = function(beforeSend) {
		return $http.post(baseUrl + 'getEmpLeaveStatus', {
			transformRequest : beforeSend
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data.emlLeaveStatus.listIt;
		});
	};
	srv.getProfile = function(beforeSend) {
		return $http({
			url : baseUrl + 'getCustomerInfo',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			async : true
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getAvatar = function(beforeSend) {
		return $http({
			url : baseUrl + 'getImageAvatar',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			async : true
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getNotification = function(beforeSend) {
		return $http({
			url : baseUrl + 'getNotification',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			async : true
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.submit = function(data, beforeSend) {
		return $http({
			url : baseUrl + 'createEmplLeaveSalesman',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : {
				leaveTypeId : data.type,
				fromDate : data.from,
				thruDate : data.to,
				emplLeaveReasonTypeId : data.reason
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	return srv;
});
// all inventory service
olbius.factory('InventoryService', function($http, $location) {
	var srv = {};
	srv.getTable = function() {
		return $http.get('table/inventory.json').then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.check = function(inventory, customerId, beforeSend) {
		return $http({
			url : baseUrl + 'updateInventoryCus',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : {
				inventory : JSON.stringify(inventory),
				party_id : customerId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	srv.getByCustomer = function(customerId, beforeSend) {
		return $http({
			url : baseUrl + 'getInventoryCusInfo',
			transformRequest : function(obj) {
				return transformRequest(obj, beforeSend);
			},
			dataType : "json",
			method : "POST",
			data : {
				partyId : customerId
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	return srv;
});
//DashBoard Services
olbius.factory('DashboardServices',function($http,$location){
	var srv= {};
	
	srv.purchaseReportProduct = function (partyId){
			return $http({
				url : baseUrl+'purchaseReportProduct',
				transformRequest : function(obj) {
					return transformRequest(obj);
				},
				dataType : "json",
				method : "POST",
				data : {
					partyId : partyId
				},
				headers : {
					'Content-Type' : 'application/x-www-form-urlencoded'
				}
			}).then(function(res) {
				checkLogin(res.data, $location);
				return res.data;
			});
	};
	srv.productSalesSum = function(month){
		console.log('month',month);
		return $http({
			url: baseUrl+'productSalesSum',
			dataType:"json",
			method : "POST",
			data: {
				month:month
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	srv.orderAmountPerMonth= function(){
		return $http({
			url :  baseUrl+ 'orderAmountPerMonth',
			method: "POST",
			dataType : "json",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
			
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	srv.customerSumAmount = function(){
		return $http({
			url :  baseUrl+ 'customerSumAmount',
			method: "POST",
			dataType : "json",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
			
		}).then(function(res){
			checkLogin(res.data,$location);
			return res.data;
		});
	};
	
	srv.getPolicySalesMan = function(){
		return $http({
		url : baseUrl + 'getPolicySalesMan',
		method: "POST",
		dataType: "json",
		headers : {
			'Content-Type' : 'application/x-www-form-urlencoded'
		}
	}).then(function(res){
		checkLogin(res.data,$location);
		return res.data;
	});
	};
	return srv;
});
//olbius.service('TestService',function($http,$location,$q){
//	this.test = function(list){
//		var deferred = $q.defer();
//		var arr = [];
//		angular.forEach(list,function(item){
//			arr.push(
//					$http({
//						url : baseUrl + 'getPolicySalesMan',
//						method: "POST",
//						async : true,
//						dataType: "json",
//						headers : {
//							'Content-Type' : 'application/x-www-form-urlencoded'
//						}
//			}));
//		});
//		$q.all(arr).then(function(results){
//			deferred.resolve(console.log('results load async Ajax : '+JSON.stringify(results)));
//		},function(errs){
//			console.log('error synchronize' + JSON.stringify(errs));
//		},function(updates){
//		});	
//	}
//});
//
//CustomerOpinion Service
olbius.factory('CustomerOpinion',function($http,$location){
	var srv = {};
	srv.submitFbCustomer = function (infoFBfromCustomer){
		console.log('info',infoFBfromCustomer);
			return $http({
				url : baseUrl + 'submitFbCustomer',
				method : "POST",
				dataType : "json",
				transformRequest : function(obj,beforeSend){
					return transformRequest(obj);
				},
				data : infoFBfromCustomer,
				headers : {
					'Content-Type' : 'application/x-www-form-urlencoded'
				}
			}).then(function(res){
				checkLogin(res.data,$location);
				return res.data;
			});
		};
		srv.submitInfoOpponent = function(opponentInfo){
			return $http({
				url : baseUrl + 'submitInfoOpponent',
				method : "POST",
				dataType : "json",
				transformRequest : function(obj,beforeSend){
					return transformRequest(obj);
				},
				data : opponentInfo,
				headers : {
					'Content-Type' : 'application/x-www-form-urlencoded'
				}
			});
		}
		srv.getListOpponent = function(){
			return $http({
				url : baseUrl + 'getListOpponent',
				method : "POST",
				dataType : "json",
				headers : {
					'Content-Type' : 'application/x-www-form-urlencoded'
				}
			});
		}
	return srv;
});

olbius.factory('UploadService', function($http, $location) {
	var srv = {};
	srv.uploadImage = function(scope, url) {
		return $http.get(baseUrl + url).then(function(response) {
			scope.loadingFiles = false;
			scope.queue = response.data.files || [];
		}, function() {
			scope.loadingFiles = false;
		});
	};

	return srv;
});

olbius.factory('GPS', ['geolocation',
function(geolocation) {
	var srv = {};
	srv.getDistance = function(first, second) {
		var R = 6371;
		// km
		var phi1 = srv.toRadians(first.lat);
		var phi2 = srv.toRadians(second.lat);
		var deltaphi = srv.toRadians(second.lat - first.lat);
		var deltalamda = srv.toRadians(second.long - first.long);
		var a = Math.sin(deltaphi / 2) * Math.sin(deltaphi / 2) + Math.cos(phi1) * Math.cos(phi2) * Math.sin(deltalamda / 2) * Math.sin(deltalamda / 2);
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		var d = R * c;
		return d;
	};
	srv.getCurrentLocation = function(scope) {
		geolocation.getLocation().then(function(position) {
			scope.currentLocation = {
				"lat" : position.coords.latitude,
				"long" : position.coords.longitude
			};
		});
	};
	srv.checkDistance = function(scope, store) {
		geolocation.getLocation().then(function(data) {
			var lat = data.coords.latitude;
			var long = data.coords.longitude;
			var distance = srv.getDistance({
				lat : lat,
				long : long
			}, store);
			console.log("distance", distance);
			if (distance <= 0.1) {
				scope.isValidDistance = true;
			}
			scope.isValidDistance = true;
		}, function(res){
			console.log(res);
		});
	};
	srv.processDistance = function(scope, current, store) {
		var distance = srv.getDistance(current, store);
		if (distance <= 0.1) {
			console.log("valid");
			scope.isValidDistance = true;
		} else {
			console.log("invalid");
			scope.isValidDistance = false;
		}
	};
	srv.toRadians = function(num) {
		var phi = num * Math.PI / 180;
		return phi;
	};
	return srv;
}]);

//Service SUP
olbius.factory('Route',function($http,$location){
	var obj = {};
	obj.createRoute = function(dt,beforeSend){
		var data = {
			routeName : dt.routeName,
			infoRoute : dt.select
		};
		return $http({
			url : baseUrl + 'createRoute',
			method  : 'POST',
			data : data,
			dataType : 'json',
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(data){
			checkLogin(data,$location);
			console.log(JSON.stringify(data) + 'success');
			return data;
		},function(){
			
		});
	};
	obj.getListRouteAndSalesMan = function(beforeSend){
		return $http({
			url : baseUrl + 'getListRouteAndSalesMan',
			method  : 'POST',
			dataType : 'json',
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(data){
			checkLogin(data,$location);
			return data;
		},function(){
			
		});
	};
	obj.distributionRouteSalesMan = function(data,beforeSend){
		var dt = {
			listDistribution : JSON.stringify(data)
		};
		return $http({
			url : baseUrl + 'distributionRouteSalesMan',
			method  : 'POST',
			dataType : 'json',
			data : dt,
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(data){
			checkLogin(data,$location);
			return data;
		},function(){
			
		});
	};
	obj.distributionRouteStores = function(data,beforeSend){
		var dt = {
			listDistributionStores : JSON.stringify(data)
		};
		console.log(JSON.stringify(dt));
		return $http({
			url : baseUrl + 'distributionRouteStores',
			method  : 'POST',
			dataType : 'json',
			data : dt,
			transformRequest : function(obj){
				return transformRequest(obj,beforeSend);
			},
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(data){
			checkLogin(data,$location);
			return data;
		},function(){
			
		});
	};
	return obj;	
});

// transform object data to request
function transformRequest(obj, callback) {
	if (callback) {
		callback();
	}
	var str = [];
	for (var p in obj)
	str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
	return str.join("&");
}

// validate user
function checkLogin(obj, $location) {
	if (obj.login === "FALSE") {
		localStorage.setItem("login", "false");
		$location.path('login');
	} else {
		localStorage.setItem("login", "true");
	}
}

function convertDistance(distance) {
	if (distance < 1) {
		var m = Math.round(distance * 1000);
		return m + "m";
	}
	var dis = Math.round(distance * 10) / 10;
	return dis + "km";
}

