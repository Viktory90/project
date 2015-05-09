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
			console.log('result'+JSON.stringify(res));
			checkLogin(res.data, $location);
			return res.data;
		});
	};
	authService.checkLogin = function() {
		console.log('userlogin');
		return $http.post(baseUrl + 'checkLogin').then(function(res) {
			return res.data.login;
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
	srv.getList = function(beforeSend, page, size, iscurrent) {
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
				current : iscurrent
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
	srv.submitOrder = function(customerId, products, beforeSend ,timeout) {
		console.log('11'+customerId + ' ' + JSON.stringify(products));
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
			},
			timeout : timeout(function(){
				console.log('Server not response');
			},10000)
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
		console.log('nam',info);
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
		var data = {};
		if(partyId){
			data.partyId = partyId;
		};
		return $http({
			url : baseUrl + 'getExhibitedDetail',
			method : "POST",
			dataType : "json",
			transformRequest : function(obj){
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
		});
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
		console.log('customerId' + customerId + 'inventory' + JSON.stringify(inventory));
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
olbius.factory('GPS', function($cordovaGeolocation, $route) {
	var srv = {};

	srv.getDistance = function(first, second) {
		var R = 6371; // km
		var phi1 = srv.toRadians(first.lat);
		var phi2 = srv.toRadians(second.lat);
		var deltaphi = srv.toRadians(second.lat - first.lat);
		var deltalamda = srv.toRadians(second.long - first.long);
		var a = Math.sin(deltaphi / 2) * Math.sin(deltaphi / 2)
				+ Math.cos(phi1) * Math.cos(phi2) * Math.sin(deltalamda / 2)
				* Math.sin(deltalamda / 2);
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		var d = R * c;
		return d;
	};
	srv.getLocationCallback = function(){
		var options = {
				frequency : 300000,
				timeout : 60000,
				maximumAge: 900000,
				enableHighAccuracy : true
			};
		return	$cordovaGeolocation.getCurrentPosition().then(function(position) {
			return {
				lat : position.coords.latitude,
				long : position.coords.longitude
			};
		}, function(err) {}, options);
	};
	srv.getCurrentLocation = function(scope, isWatch) {
		var options = {
			frequency : 300000,
			timeout : 60000,
			maximumAge: 900000,
			enableHighAccuracy : true
		};
		$cordovaGeolocation.getCurrentPosition().then(function(position) {
			scope.currentLocation = {
				lat : position.coords.latitude,
				long : position.coords.longitude
			};
			console.log("current location" + JSON.stringify(scope.currentLocation));
		}, function(err) {
			console.log("cannot get location : ", JSON.stringify(err));
			bootbox.confirm("Bật kết nối GPS & thử lại", function(){
				$route.reload();
			});
		}, options);
		if(isWatch){
			srv.watch = $cordovaGeolocation.watchPosition(options);
			localStorage.setItem("watchid", srv.watch.watchId);
			srv.watch.promise.then(function() { /* Not used */
			}, function(err) {
				console.log("Cannot get current location " + JSON.stringify(err));
				bootbox.confirm("Bật kết nối GPS & thử lại", function(){
					$route.reload();
				});
			}, function(position) {
				scope.currentLocation = {
					lat : position.coords.latitude,
					long : position.coords.longitude
				};
				console.log("current location watch" + JSON.stringify(scope.currentLocation));
			});
		}
	};
	srv.toRadians = function(num) {
		var phi = num * Math.PI / 180;
		return phi;
	};
	srv.checkDistance = function(scope, store) {
		var options = {
			frequency : 300000,
			timeout : 60000,
			maximumAge: 900000,
			enableHighAccuracy : true
		};
		$cordovaGeolocation.getCurrentPosition().then(function(position) {
			var lat = position.coords.latitude;
			var long = position.coords.longitude;
			var distance = srv.getDistance({
				lat : lat,
				long : long
			}, store);
			if (distance <= config.distance) {
				scope.isValidDistance = true;
			}
			scope.isValidDistance = true;
		}, function(err) {
			console.log("cannot get location : ", JSON.stringify(err));
			bootbox.confirm("Bật kết nối GPS & thử lại", function(){
				$route.reload();
			});
		}, options);
	};
	srv.processDistance = function(scope, current, store) {
		var distance = srv.getDistance(current, store);
		console.log(1231);
		if (distance <= config.distance) {
			console.log("valid");
			scope.isValidDistance = true;
		}else{
			console.log("invalid");
			scope.isValidDistance = false;
		}
		scope.isValidDistance = true;
	};
	return srv;
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

