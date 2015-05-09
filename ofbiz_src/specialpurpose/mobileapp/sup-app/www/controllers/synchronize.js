/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('SynchronizeController', function($rootScope, $scope, $controller,$timeout,SynchronizeService, ProductService, SqlService,OrderService ,InventoryService ,aSynchronizeService ,CustomerService,CustomerOpinion) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	$scope.hide = false;
	$scope.total = 0;
	$scope.current = 0;
	$scope.notification = "";
	$scope.support = {
		condition: ["PROMO_GWP", "PROMO_PROD_DISC"],
		action: ["PPIP_PRODUCT_QUANT", "PPIP_PRODUCT_TOTAL"]
	};
	$scope.$on("$viewContentLoaded", function() {
		$scope.setHeader("Đồng bộ hóa", "/main", false);
		$scope.getInfoFromSQLite();
		if (!localStorage.customers) {
			$location.path("store");
		} else {
			$scope.currentStore = JSON.parse(localStorage.getItem("currentCustomer"));
		}
	});
	$scope.initData = function() {
		SynchronizeService.getPromotions().then(function(res) {
			var data = res.promotions;
			console.log('pp'+JSON.stringify(data));
			var id = getLastInsertId("lastPromotionId");
			if (data && data.length) {
				var fields = ["id", "productPromoId", "inputParamEnumId", "productPromoActionEnumId", "amount", "quantity", "productId", "fromDate", "thruDate", "productPromoRuleId", "orderAdjustmentTypeId", "operatorEnumId", "productPromoCondSeqId", "productPromoActionSeqId", "productPromoApplEnumId", "condValue", "partyId", "otherValue","ruleName"];
				console.log("fields length" + fields.length);
				var input = Array();
				for (var x in data) {
					var obj = data[x];
					var tmp = [id, obj.productPromoId, obj.inputParamEnumId, obj.productPromoActionEnumId, obj.amount, obj.quantity, obj.productId, formatDateDMY(obj.fromDate.time), formatDateDMY(obj.thruDate.time), obj.productPromoRuleId, obj.orderAdjustmentTypeId, obj.operatorEnumId, obj.productPromoCondSeqId, obj.productPromoActionSeqId, obj.productPromoApplEnumId, obj.condValue, obj.partyId, obj.otherValue,obj.ruleName];
					input.push(tmp);
					id++;
				}
				SqlService.deleteRow("promotions").then(function() {
					SqlService.insert("promotions", fields, input).then(function(res) {
						/*SqlService.select("promotions").then(function(res){
							console.log(" promotions" + JSON.stringify(res));
						});*/
						localStorage.setItem("lastPromotionId", id);
					}, function() {
						log("error" + JSON.stringify(res));
					});
				});
			}
		}, function(err) {
			console.log("get promotions" + JSON.stringify(err));
		});
		ProductService.getAll().then(function(res) {
			var data = res.listProduct;
			var id = getLastInsertId("lastProductId");
			if (data && data.length) {
				var fields = ["id", "productId", "productName", "unitPrice"];
				var input = Array();
				for (var x in data) {
					var obj = data[x];
					var tmp = [id, obj.productId, obj.productName, obj.unitPrice];
					input.push(tmp);
					id++;
				}
				SqlService.deleteRow("products").then(function() {
					SqlService.insert("products", fields, input).then(function(tx, res) {
					
					}, function() {
						log("error" + JSON.stringify(res));
					});
				});
			}
		});
		CustomerService.getAll(0,100,null).then(function(data){
			$scope.customers= data.customers;
			var key = 'listStore';
			if(!localStorage.getItem(key)){
				localStorage.setItem(key,JSON.stringify(data.customers));
				console.log('list Store'+ JSON.stringify(localStorage.getItem(key)));
			}
		});
		//get ListExhibited for Store
		ProductService.getExhibitedDetail().then(function(data){
			var fields = ["productPromoId","promoName","fromDate","thruDate","quantity","amount","productId","operatorEnumId","condValue","condExhibited","productPromoRuleId","ruleName","productName"];
			var obj  = {};
			if(data.listExhibited){
				obj  = data.listExhibited;
			};
			var input = [];
			for(var key in obj){
				var value = [obj[key].productPromoId,obj[key].promoName,formatDateDMY(obj[key].fromDate.time),formatDateDMY(obj[key].thruDate.time),obj[key].quantity,obj[key].amount,obj[key].productId,obj[key].operatorEnumId,obj[key].condValue,obj[key].condExhibited,obj[key].productPromoRuleId,obj[key].ruleName,obj[key].productName]; 				
				console.log('valuee' + JSON.stringify(value));
				input.push(value);
			};
			SqlService.insert('exhibite',fields,input).then(function(data){
				console.log('INSERT EXHIBITE SUCCESS' + JSON.stringify(data));
			},function(err){
				console.log('INSERT EXHIBITE ERROR' + JSON.stringify(err));
			});
		},function(err){
					console.log('get list exhibited failed' + JSON.stringify(err));	
		});
		CustomerOpinion.getListOpponent().then(function(data) {
			console.log('opponent' + JSON.stringify(data.data.listOpponent));
			if(data.data.listOpponent){
				localStorage.setItem('listOpponent',JSON.stringify(data.data.listOpponent));
			}
		},function(err){
			console.log('get list opponent error');
		});
		setTimeout(function(){
			$scope.checkSyncComplete.getData = false;
		},60000);
		bootbox.alert('Lấy dữ liệu thành công');	
	};
	$scope.comfirmgetData  = function(){
		bootbox.confirm('Đồng bộ dữ liệu từ Server?',function(result){
			if(result) {
				$scope.checkSyncComplete.getData = true;
				$scope.initData();	
			}; 
		});
	};
	$scope.infoSynchronize = {
		total : 0,
		totalSuccess : 0,
		totalError : 0,
		percent : 0,
		totalOrder : 0,
		totalOrderSuccess : 0,
		totalOrderError : 0,
		percentOrder : 0,
		totalInventory : 0,
		totalInventorySuccess : 0,
		totalInventoryError : 0,
		percentInventory : 0,
		infoDetail : []
	};
	$scope.getInfoFromSQLite = function(){
		var query = "SELECT count(customerId) from customer";
		SqlService.query(query).then(function(data){
			if(data[0]['count(customerId)']){
				$scope.infoSynchronize.total = data[0]['count(customerId)'];
			}
		},function(){
			
		});
		var query =  "SELECT count(oridInfoId) FROM orderinfo";
		SqlService.query(query).then(function(data){
			console.log('ORDER' + JSON.stringify(data));
			if(data[0]['count(oridInfoId)']){
				$scope.infoSynchronize.totalOrder = data[0]['count(oridInfoId)'];
			}
		},function(){
			
		});
		var query = "SELECT count(ivid) from inventories";
		SqlService.query(query).then(function(data){
			if(data[0]['count(ivid)']){
				$scope.infoSynchronize.totalInventory = data[0]['count(ivid)'];
			}
		},function(){
			
		});
	};
	$scope.SyncchornizeCustomer = function(){
		var query = "SELECT * from customer";
		SqlService.query(query).then(function(data){
			aSynchronizeService.loadSyncCustomer(data).then(function(data){
				console.log('sss'+JSON.stringify(data));
				if(data.total || data.totalSuccess){
					$scope.infoSynchronize.total = data.total;
					$scope.infoSynchronize.totalSuccess = data.totalSucess;
					$scope.infoSynchronize.totalError = $scope.infoSynchronize.total - $scope.infoSynchronize.totalSuccess;
					console.log('vvv'+$scope.infoSynchronize.totalError + $scope.infoSynchronize.totalSuccess + $scope.infoSynchronize.total);
					$scope.infoSynchronize.percent = $scope.infoSynchronize.totalSuccess / $scope.infoSynchronize.total *100;
					for(var key in data.info){
						$scope.infoSynchronize.infoDetail.push(data.info[key]);
						}
				};
			},function(data){
				console.log('SSS' + JSON.stringify(data));				
			});
			console.log('get customer info error');
		});
	};
	$scope.SynchronizeInventory = function(){
		var query = "SELECT * FROM inventories ORDER BY customerId";
		var currentCustomer = '';
		var listInventory = [];
		var inventory = [];
		var currentid = '';
		
		SqlService.query(query).then(function(data){
			console.log('data Inventory' + JSON.stringify(data));
			if(data && data.length >0 ){	
				for(var key in data){
					if(currentCustomer && currentCustomer != data[key].customerId){
						listInventory.push({
							party_id : currentCustomer,
							inventory : inventory,
							ivid : currentid
						});
						inventory = [];
						currentCustomer = data[key].customerId;
						currentid = data[key].ivid;
					}else {
						currentCustomer = data[key].customerId;
						currentid = data[key].ivid;
						inventory.push({productId : data[key].productId , qtyInInventory : data[key].quantity , orderId : data[key].orderId});
					}
					if(!currentCustomer){
						currentCustomer = data[key].customerId;
					}
					if(!currentid){
						currentid = data[key].ivid;
					}
				}	
				listInventory.push({
					party_id : currentCustomer,
					inventory : inventory,
					ivid : currentid
				});
			//sync inventory	
				aSynchronizeService.loadSyncInventory(listInventory).then(function(data){
					console.log('asus' + JSON.stringify(data));
					if(data){
						$scope.infoSynchronize.totalInventorySuccess = data.success;
						$scope.infoSynchronize.totalInventoryError = $scope.infoSynchronize.totalInventory - $scope.infoSynchronize.totalInventorySuccess;
						$scope.infoSynchronize.percentInventory = $scope.infoSynchronize.totalInventorySuccess / $scope.infoSynchronize.totalInventory *100;
						console.log('percent inventory' + $scope.infoSynchronize.percentInventory + 
								'success : ' + $scope.infoSynchronize.totalInventorySuccess 
								+ 'error' +$scope.infoSynchronize.totalInventoryError 
						);
					};
					},function(err){
					console.log('asus' + JSON.stringify(err));
				});
			};
			},function(err){
				console.log('error get data Inventory');
			});
		
	};
	$scope.checkSyncComplete = {
		getData : false,
		Synchronize : false
	};
	$scope.conFirm = function(){
		bootbox.confirm('Bạn có muốn đồng bộ dữ liệu ?',function(result){
			console.log(JSON.stringify('result'+result));
			if(result){
				$scope.checkSyncComplete.Synchronize = true;
				$scope.SynchronizeDataFinalize();	
				result = false;
			};
		});
	};
	$scope.SynchronizeDataFinalize = function(){
		if($rootScope.network.status){
			$scope.SynchronizeOrder();
			$scope.SyncchornizeCustomer();
			$scope.SynchronizeExhibitedRegister();
			$scope.SynchronizeInventory();
			setTimeout(function(){
				$scope.checkSyncComplete.Synchronize = false;
				$scope.infoSynchronize = {};
			},7000);
		}else{
			 bootbox.alert('Bật mạng trước khi thực hiện đồng bộ');
			$scope.checkSyncComplete.Synchronize = false;
		}
	};
	$scope.SynchronizeExhibitedRegister = function(){
		var query = "SELECT * FROM exhibitedRegister";
		SqlService.query(query).then(function(data){
			var infoExhibitedRegister = {};
			log('data exhibited REgis' + JSON.stringify(data));
			aSynchronizeService.loadSyncCommon(data,'exhibitedRegister').then(function(data){
				infoExhibitedRegister = data;
			},function(err){
				infoExhibitedRegister = err;					
			});
		},function(){
			console.log("can't get data exhibited Register");
		});
	};
	$scope.SynchronizeOrder = function(){
		var query = "SELECT * FROM orderinfo as oi, orders as o WHERE o.oridInfoId = oi.oridInfoId ORDER BY oridInfoId"; 
		SqlService.query(query).then(function(res){
			console.log('order' + JSON.stringify(res));
			var listOrder = [];
			var currentOrder = '';
			var currentCustomer = "";
			var pro = [];
			var products = "";
			var currentOrid = "";
			for(var x in res){
				if(currentOrder && currentOrder != res[x].oridInfoId){
					listOrder.push({
						products: pro,
						customerId : currentCustomer,
						orid : currentOrid , 
						oridInfoId : currentOrder
					});
					pro = [];
					pro.push({quantity: res[x].quantity, productId: res[x].productId });
					currentOrder = res[x].oridInfoId;
					currentCustomer = res[x].customerId;
					currentOrid  = res[x].orid;
				}else{
					if(res[x].productId){
						pro.push({quantity: res[x].quantity, productId: res[x].productId});
					}
				}
				if(!currentOrder){
					currentOrder = res[x].oridInfoId;
				}
				if(!currentCustomer){
					currentCustomer = res[x].customerId;
				}
				if(!currentOrid){
					currentOrid = res[x].orid;
				}
			}
			listOrder.push({
				products: pro,
				customerId : currentCustomer,
				orid : currentOrid, 
				oridInfoId : currentOrder
			});
			console.log('listOrder' + listOrder.length);
			if(listOrder[0].customerId && listOrder.length > 0 ){
				aSynchronizeService.loadSync(listOrder).then(function(data){//xem lai dong bo order
					console.log('aaa'+JSON.stringify(data));
				if(data){
					$scope.infoSynchronize.totalOrderSuccess = data.totalSuccess;
					$scope.infoSynchronize.totalOrderError = data.totalOrder - data.totalSuccess;
					$scope.infoSynchronize.percentOrder = $scope.infoSynchronize.totalOrderSuccess / $scope.infoSynchronize.totalOrderSuccess *100;
					console.log('vvv'+JSON.stringify($scope.infoSynchronize));
				}	
				},function(err){
					console.log('aaa'+JSON.stringify(err));
				});
			}
		},function(){
			console.log('error get data from Sqlite');
		});
	};
	$scope.deleteOldData = function(){
		for(var x in db){
			SqlService.deleteAll(db[x]);
		}
		localStorage.clear();
	};
	$scope.notSupportPromotions = function(data){
		var cond = data.inputParamEnumId;
		var action = data.productPromoActionEnumId;
		var flag1 = _.contain($scope.support.condition, cond);
		var flag2 = _.contain($scope.support.action, action);
		if(!flag1 || !flag2){
			var str = "<div class='row'><div class='col-xs-12 col-sm-12'>"
					+ data.promoName
					+ "</div></div>";
			$("#result-not-support");
		}else{
			$("#result-support");
		}
	};
	
});
