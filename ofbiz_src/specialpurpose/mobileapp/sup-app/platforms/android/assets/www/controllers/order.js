/*
 * controller for create order
 * */
olbius.controller('CreateOrderController', function($rootScope, $scope, $controller, $timeout, $location,$compile,$cordovaNetwork, OrderService, ProductService, SqlService, GPS) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	//current road selected
	$scope.notification = "";
	$scope.currentStore = null;
	$scope.currentInventory = null;
	$scope.pageSize = 10;
	$scope.current = 1;
	$scope.total = 0;
	$scope.promotions = [];
	$scope.products = [];
	$scope.promosProcessed = 0;
	$scope.bought = [];
	//scope isolated
	$scope.isValidDistance = true;
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader('CreateOrder', "/main", false);
		if (!localStorage.customers) {
			$location.path("store");
		} else {
			$scope.currentStore = JSON.parse(localStorage.getItem("currentCustomer"));
		}
		$scope.reloadDistance();
		$scope.initProduct();
		$scope.getLastInventory();
		initModal();
	});
	/* check distance is valid to create order */
	$scope.initProduct = function() {
		$scope.checkOrderSynchronize();
		var data = [];
		data = $.parseJSON(localStorage.getItem('listProducts'));
		if (data) {
			$scope.initQuantity(data);
		}
		$scope.initProductPagination();
	};
	$scope.initQuantity = function(data) {
		for (var x in data) {
			data[x].expiry_date = "";
			data[x].quantity = null;
		}
		$scope.products = data;
	};
	$scope.initProductPagination = function() {
		var length = $scope.products.length;
		if (length) {
			getPage($scope.products, 1);
			$scope.total = Math.ceil(length / $scope.pageSize);
			generatePagination();
			changePaginationStyle(1);
		}
	};
	$scope.next = function() {
		if ($scope.current < $scope.total) {
			var tmp = $scope.current + 1;
			changePaginationStyle(tmp);
			$scope.current = tmp;
			getPage($scope.products, $scope.current);
		}
	};
	$scope.previous = function() {
		if ($scope.current > 1) {
			var tmp = $scope.current - 1;
			changePaginationStyle(tmp);
			$scope.current = tmp;
			getPage($scope.products, $scope.current);
		}
	};
	var generatePagination = function() {
		var str = "";
		if ($scope.total > 1) {
			var tmp = 0;
			for (var x = 0; x < $scope.total; x++) {
				tmp = parseInt(x + 1);
				str += "<button class='btn page-item' id='page-" + tmp + "' ng-click='pagination(" + tmp + ")'>" + tmp + "</button>";
			}
		}
		$("#paginationNumber").html(str);
		$compile($("#paginationNumber").contents())($scope);
	};
	$scope.pagination = function(page) {
		changePaginationStyle(page);
		$scope.current = page;
		getPage($scope.products, $scope.current);
	};
	var changePaginationStyle = function(page) {
		if (page != $scope.current) {
			$("#page-" + $scope.current).removeClass("page-active");
			$("#page-" + page).addClass("page-active");
		} else {
			$("#page-" + page).addClass("page-active");
		}
	};
	var getPage = function(data, page) {
		var end = data.length;
		var start = (page - 1) * $scope.pageSize;
		var to = start + $scope.pageSize;
		var limit = end < to ? end : to;
		var str = "";
		// for (var x = start; x < limit; x++) {
		for (var x = 0; x < data.length; x++) {
			var product = data[x];
			str += "<tr>";
			str += "<td>" + product.productId + "</td>";
			str += "<td>" + product.productName + "</td>";
			str += "<td style='text-align:right;'>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
			str += "<td><input type='number' class='number' placeholder='0' id='quantity" + product.productId + "' ng-model='products[" + x + "].quantity'/></td>";
			str += "</tr>";
		}
		$("#listProducts").html(str);
		$compile($("#listProducts").contents())($scope);
	};
	/* get latest check inventory of salesman */
	$scope.getLastInventory = function() {
		if ($scope.currentStore) {
			var key = "creatingorder_" + $scope.currentStore.partyIdTo;
			if (localStorage[key]) {
				var data = JSON.parse(localStorage[key]);
				for (var x in $scope.products) {
					var obj = $scope.findProduct(data, $scope.products[x].productId);
					if (obj) {
						$scope.products[x].quantity = obj.qtyInInventory;
					}
				}
			}
		}
	};
	$scope.findProduct = function(data, key) {
		var res = _.where(data, {
			productId : key
		});
		if (res.length) {
			var obj = {};
			var total = 0;
			for (var x in res) {
				obj = res[x];
				total += res[x].qtyInInventory;
			}
			obj.qtyInInventory = total;
			return obj;
		}
	};
	$scope.getAllProduct = function() {
		if(localStorage.getItem('listProducts')){
			$scope.products = $.parseJSON(localStorage.getItem('listProducts'));
		}
		// ProductService.getAll(function() {
		// }).then(function(res) {
			// if (res.listProduct) {
				// $scope.products = res.listProduct;
				// if ($scope.products.length) {
					// localStorage.setItem("products", JSON.stringify(res.listProduct));
				// }
			// }
		// }, function(res) {
			// console.log("error" + JSON.stringify(res));
		// });
	};
	$scope.reloadDistance = function() {
		if ($scope.currentStore) {
			var point = {
				lat : $scope.currentStore.latitude,
				long : $scope.currentStore.longitude
			};
			GPS.checkDistance($scope, point);
		}
	};
	$scope.btcreateOrder = function(){
		if($scope.products && $scope.products.length > 0){
			bodyOrder = '<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >';
			bodyOrder = '<table class="table table-striped table-bordered table-hover products"><thead><tr>';		
			bodyOrder += '<th class="center">Mã SP</th>';		
			bodyOrder += '<th class="center">Tên SP</th>';	
			bodyOrder += '<th class="center">Giá</th>';	
			bodyOrder += '<th class="center">SL</th>';	
			var str = "";
			for (var x in $scope.products) {
				var product = $scope.products[x];
				if (product.quantity) {
					str += "<tr><td>" + product.productId + "</td>";
					str += "<td>" + product.productName + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.quantity) + "</td>";
					str += "</tr>";
				}
			}
			bodyOrder += '</tr></thead><tbody>'+ str +'</tbody></table>';	
			bodyOrder += '<div class="row"><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right"></div><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right">';
			bodyOrder += 'Tổng tiền : <b class="theme-color" >'+ $scope.FormatNumberBy3($scope.calculateTotalCost()) + 'đ</b></div></div></div>';
		}else {
			bodyOrder = $rootScope.Map.NotiChooseProductsInOrder[$rootScope.key];
		}
		BootstrapDialog.show({
							title : 'Chi tiết đơn hàng',
				            message: bodyOrder,
				            type : BootstrapDialog.TYPE_SUCCESS,
				            closable : false,
				            spinicon : 'fa fa-spinner',
				            buttons: [{
				                icon: 'glyphicon glyphicon-ok',
				                label: 'ok',
				                cssClass: 'btn-primary',
				                autospin: true,
				                action: function(dialogRef){
				                    dialogRef.enableButtons(false);
				                    dialogRef.setClosable(false);
				                    $scope.submitOrder();
			                        dialogRef.close();
				                }
				            },{
				            	icon : 'fa fa-times',
				            	label : 'Cancel',
				            	action : function(dialogRef){
				            		dialogRef.close();
				            	}
				            }]
				        }); 
	};
	/* submit order to server
	 * input: list product id vs quantity */
	var bodyOrder = '';
	$scope.submitOrder = function() {
		var products = "";
		var renderTable = '<table class="table table-striped table-bordered table-hover products"><thead>';
			renderTable += '<th class="center">Mã SP</th>';		
			renderTable += '<th class="center">Tên SP</th>';	
			renderTable += '<th class="center">SL</th>';	
			renderTable += '<th class="center">Giá</th></thead><tbody><tr>';	
		var customer = $scope.currentStore.partyIdTo;
		var input = Array();
		for (var x in $scope.products) {
			var product = $scope.products[x];
			var id = new Date().getTime();
			if (product.quantity) {
				var tmp = [ $scope.products[x].productId, $scope.products[x].quantity,formatDateYMD(id)];
				input.push(tmp);
				var tmpPro = JSON.parse(JSON.stringify($scope.products[x]));
				$scope.bought.push(tmpPro);
				id++;
				if (x != 0) {
					products += "||";
				}
				products += $scope.products[x].productId + "%%" + $scope.products[x].quantity;
			}
		}
		if (!products) {
			$scope.showNotify($rootScope.Map.SelectminimumProduct[$rootScope.key], false);
			return;
		}
		// create order online
		if($rootScope.network.status){
			if($scope.isOpenDialog){
					BootstrapDialog.show({
						title : $rootScope.Map.Notification[$rootScope.key],
			            message: $rootScope.Map.NotiSyncOrder[$rootScope.key],
			            type : BootstrapDialog.TYPE_SUCCESS,
			            closable : false,
			            spinicon : 'fa fa-spinner',
			            buttons: [{
			                icon: 'glyphicon glyphicon-ok',
			                label: $rootScope.Map.Ok[$rootScope.key],
			                cssClass: 'btn-primary',
			                autospin: true,
			                action: function(dialogRef){
			                    dialogRef.enableButtons(false);
			                    dialogRef.setClosable(false);
			                    dialogRef.getModalBody().html($rootScope.Map.MoveSynchronize[$rootScope.key]);
			                    setTimeout(function(){
			                        dialogRef.close();
			                        $location.path('sync');
			                        $scope.$apply();
			                    }, 2000);
			                }
			            }, {
			            	icon : 'fa fa-ban',
			                label: $rootScope.Map.Cancel[$rootScope.key],
			                action: function(dialogRef){
			                    dialogRef.close();
			                }
			            }]
			        }); 
			}else {
			 OrderService.submitOrder(customer, products, $rootScope.showLoading ,$timeout).then(function(data) {
				 $scope.PaymentTotal = data.res["PaymenTotal"];
				 var infoProductPromo = [];
				 	for (var r in data.res["OrderInfo"]) {
						 var pct = {};
						 pct = {
								productName :  data.res["OrderInfo"][r].productName,
								productId : data.res["OrderInfo"][r].productId,
								productQuantity : data.res["OrderInfo"][r].productQuantity,
								productPrice : data.res["OrderInfo"][r].productPrice
						 };
						if(infoProductPromo.length == 0){
							infoProductPromo.push(pct);
						}else {
							for(var pp in infoProductPromo){
								if(infoProductPromo[pp].productId == pct.productId){
									infoProductPromo[pp].productQuantity += pct.productQuantity;
								}else {
									infoProductPromo.push(pct);
								};
							}
						}
				 	};
				 	if(infoProductPromo && infoProductPromo.length > 0){
				 		for(var pp in infoProductPromo){
								 renderTable += "<td>" + infoProductPromo[pp].productId + "</td>";
								 renderTable += "<td>" + infoProductPromo[pp].productName + "</td>";
								 renderTable += "<td>" + infoProductPromo[pp].productQuantity + "</td>";
								 renderTable +="<td>" + $scope.FormatNumberBy3(infoProductPromo[pp].productPrice) + "</td>";
				 		}
				 	};
				 	renderTable += "</tr><tbody></table>";
					 $("#GiftProduct").html(renderTable);
			bodyOrder = '<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >';
			bodyOrder = '<table class="table table-striped table-bordered table-hover products"><thead><tr>';		
			bodyOrder += '<th class="center">Mã SP</th>';		
			bodyOrder += '<th class="center">Tên SP</th>';	
			bodyOrder += '<th class="center">Giá</th>';	
			bodyOrder += '<th class="center">SL</th>';	
			var str = "";
			for (var x in $scope.products) {
				var product = $scope.products[x];
				if (product.quantity) {
					str += "<tr><td>" + product.productId + "</td>";
					str += "<td>" + product.productName + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.quantity) + "</td>";
					str += "</tr>";
				}
			}
			bodyOrder += '</tr></thead><tbody>'+ str +'</tbody></table>';	
			bodyOrder += '<div class="row"><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right"></div><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right">';
			bodyOrder += 'Tổng tiền : <b class="theme-color" >'+ $scope.FormatNumberBy3($scope.calculateTotalCost()) + 'đ</b></div></div></div>';
			if(data.res["OrderInfo"] && data.res["OrderInfo"].length > 0 ){
				bodyOrder += '<div style="height:28px" class="row"><div class="width-80 label label-info label-xlg arrowed-in arrowed-in-right headerPromotions"><h4 class="widget-title col-xs-12 col-md-12 white-color" style="margin : 0 auto 0 auto">Chi tiết khuyến mại</h4></div></div>';	
				bodyOrder += renderTable + '</div>';
			}
				 $scope.checkPromo = true;
				 $rootScope.hideLoading();
				 $('#submitorder').modal('hide');
				 // $rootScope.openDialog($rootScope.Map.CreateOrderSuccess[$rootScope.key]);
				 BootstrapDialog.show({
								title : $rootScope.Map.CreateOrderSuccess[$rootScope.key],
					            message: bodyOrder,
					            type : BootstrapDialog.TYPE_SUCCESS,
					            closable : true,
					            spinicon : 'fa fa-spinner',
					            buttons: [{
					                icon: 'glyphicon glyphicon-ok',
					                label: $rootScope.Map.Ok[$rootScope.key],
					                cssClass: 'btn-primary',
					                autospin: true,
					                action: function(dialogRef){
					                    dialogRef.enableButtons(false);
					                    dialogRef.setClosable(false);
					                    dialogRef.getModalBody().html(renderTable);
			                        	dialogRef.close();
					                }
					            }]
					        }); 
				 // $scope.showNotify($rootScope.Map.CreateOrderSuccess[$rootScope.key], true);
				 $scope.initQuantity($scope.products);
			 },function(err){
				 // $timeout(function(){
				 	console.log("timeout promotions");
						$scope.checkPromotions($scope.bought);
						$scope.insertOrderInfo(input);
						$rootScope.hideLoading();
				 // },10000);
			 });
			 }
		}else {
			console.log("normal promotions");
				$scope.checkPromotions($scope.bought);
				$scope.insertOrderInfo(input);
			}
	};
	$scope.insertOrderInfo = function(input){
		$rootScope.showLoading();
		$('#submitorder').modal('hide');
			var id = new Date().getTime();
			var fields = ["oridInfoId","customerId","latitude","longitude"];
			var point = GPS.getLocationCallback().then(function(pos){
				var value = [id,$scope.currentStore.partyIdTo,pos.lat,pos.long];
				var inputTmp = Array();
				inputTmp.push(value);
				if(inputTmp && inputTmp.length > 0){
					SqlService.insert("orderinfo",fields,inputTmp).then(function(res){
						$scope.insertOrderOffline(input,id);
					},function(){
						log('insert orderinfo error');
					});
				}
		},function(err){
			$rootScope.hideLoading();
			BootstrapDialog.show({
							title : $rootScope.Map.Notification[$rootScope.key],
				            message: $rootScope.Map.checkGPS[$rootScope.key],
				            type : BootstrapDialog.TYPE_SUCCESS,
				            closable : false,
				            spinicon : 'fa fa-spinner',
				            buttons: [{
				                icon: 'glyphicon glyphicon-ok',
				                label: $rootScope.Map.Ok[$rootScope.key],
				                cssClass: 'btn-primary',
				                autospin: true,
				                action: function(dialogRef){
				                    dialogRef.enableButtons(false);
				                    dialogRef.setClosable(false);
				                    $route.reload();
			                        dialogRef.close();
				                }
				            }]
				        }); 
		});
	};
	$scope.$watch('isOrder',function(){
		if($scope.isOrder){
			$scope.isOpenDialog = true;
		}else $scope.isOpenDialog = false;
	});
	$scope.isOrder = false;
	$scope.isOpenDialog = false;
	$scope.checkOrderSynchronize = function(){
		var query =  "SELECT count(oridInfoId) FROM orderinfo";
		SqlService.query(query).then(function(data){
			if(data[0]['count(oridInfoId)'] > 0){
				$scope.isOrder = true;
			}else $scope.isOrder = false;
		},function(){
			
		});
	};
	$scope.insertOrderOffline = function(input,id){
		if(id){
			for(var x in input){
				input[x].push(id);
			}	
		}
		var fields = ["productId", "quantity", "orderDate","oridInfoId"];
		SqlService.insert("orderlist", fields, input).then(function(res) {
			$rootScope.hideLoading();
			bodyOrder = '<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" >';
			bodyOrder = '<table class="table table-striped table-bordered table-hover products"><thead><tr>';		
			bodyOrder += '<th class="center">Mã SP</th>';		
			bodyOrder += '<th class="center">Tên SP</th>';	
			bodyOrder += '<th class="center">Giá</th>';	
			bodyOrder += '<th class="center">SL</th>';	
			var str = "";
			for (var x in $scope.products) {
				var product = $scope.products[x];
				if (product.quantity) {
					str += "<tr><td>" + product.productId + "</td>";
					str += "<td>" + product.productName + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.quantity) + "</td>";
					str += "</tr></tbody></table>";
				}
			}
			bodyOrder += '</tr></thead><tbody>'+ str +'</tbody></table>';	
			bodyOrder += '<div class="row"><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right"></div><div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="text-align: right">';
			bodyOrder += 'Tổng tiền : <b class="theme-color" >'+ $scope.FormatNumberBy3($scope.calculateTotalCost()) + 'đ</b></div></div></div>';
			if($scope.promotions.length > 0 ){
				bodyOrder += '<div style="height:28px" class="row"><div class="width-80 label label-info label-xlg arrowed-in arrowed-in-right headerPromotions"><h4 class="widget-title col-xs-12 col-md-12 white-color" style="margin : 0 auto 0 auto">Chi tiết khuyến mại</h4></div></div>';	
				bodyOrder += strOff + '</div>';
			}
				 $scope.checkPromo = true;
				 // $rootScope.openDialog($rootScope.Map.CreateOrderSuccess[$rootScope.key]);
				 BootstrapDialog.show({
								title : $rootScope.Map.CreateOrderSuccess[$rootScope.key],
					            message: bodyOrder,
					            type : BootstrapDialog.TYPE_SUCCESS,
					            closable : true,
					            spinicon : 'fa fa-spinner',
					            buttons: [{
					                icon: 'glyphicon glyphicon-ok',
					                label: $rootScope.Map.Ok[$rootScope.key],
					                cssClass: 'btn-primary',
					                autospin: true,
					                action: function(dialogRef){
					                    dialogRef.enableButtons(false);
					                    dialogRef.setClosable(false);
					                    dialogRef.getModalBody().html(bodyOrder);
					                    $scope.promotions = new Array();
					                    $scope.bought = new Array();
					                    bodyOrder = '';
			                        	dialogRef.close();
					                }
					            }]
					        }); 
					        
			// $rootScope.openDialog($rootScope.Map.CreateOrderOfflineSuccess[$rootScope.key]);
			// $scope.showNotify($rootScope.Map.CreateOrderOfflineSuccess[$rootScope.key], true);
		},function(err){
			$rootScope.hideLoading();
			$rootScope.openDialog($rootScope.Map.CreateOrderError[$rootScope.key]);
		});
	};
	//clear all payment detail when submit order online
	$scope.checkPromo = false;
	$scope.clearPaymentTotal = function() {
		$scope.PaymentTotal = 0;
		$scope.checkPromo = false;
		$("#GiftProduct").html("");
		$("#productOrderBody").html("");
		$("#total-amount").html("0 đ");
	};
	/*calculate total cost of order*/
	$scope.calculateTotalCost = function() {
		var total = 0;
		var data = $scope.products;
		for (var x in data) {
			var obj = data[x];
			if (obj.quantity && obj.unitPrice) {
				total += obj.quantity * obj.unitPrice;
			}
		}
		return total;
	};
	var strOff = '';
	$scope.$watch('promosProcessed', function() {
	var length = $scope.bought.length;
		if ($scope.promosProcessed && length && $scope.promosProcessed >= length) {
			if ($scope.promotions.length) {
				 strOff = "<table class='table table-striped table-bordered table-hover products'>" + "<thead><tr><th class='center'>Mã SP</th>" + "<th class='center'>Tên SP</th><th class='center'>SL</th><th class='center'>Giá</th></tr></thead><tbody>";
				for (var x in $scope.promotions) {
					var obj = $scope.promotions[x];
					strOff += $scope.renderProductPromotions(obj);
				}
				strOff += "</tbody></table>";
				$("#promotions").html(strOff);
			}
			$scope.calculateCartAmount();
		}
	});
	$scope.checkPromotions = function(input) {
		console.log("check promotions");
		for (var x in input) {
			(function(x) {	
				var query = $scope.buildQuery(input[x].productId);
				SqlService.query(query).then(function(res) {
					$scope.promosProcessed++;
					if (res && res.length) {
						$scope.calculatePromotions(res, input[x]);
					}
				}, function() {
					$scope.promosProcessed++;
				});
			})(x);
		}
	};
	$scope.buildQuery = function(productId) {
		var query = "SELECT t1.*, p.productName as acproductName, p.unitPrice as acunitPrice ";
		query += " FROM ( SELECT pm.*, p.productName as cproductName, p.unitPrice as cunitPrice FROM ";
		query += " (SELECT p1.inputParamEnumId, p1.condValue, p1.amount as amount, p1.productId as cproductId, p2.productId as acproductId, p2.productPromoActionEnumId, p2.quantity";
		query += " FROM (SELECT a.* FROM promotions as a WHERE ";
		query += " a.productId = '" + productId + "' AND ";
		query += " a.productPromoCondSeqId != '_NA_') as p1, ";
		query += " (SELECT b.* FROM promotions as b WHERE ";
		query += " b.productPromoActionSeqId != '_NA_') as p2 WHERE ";
		query += " p1.productPromoId = p2.productPromoId AND p1.productPromoRuleId = p2.productPromoRuleId) as pm, products as p WHERE ";
		query += " pm.cproductId = p.productId ) as t1, products as p WHERE t1.acproductId = p.productId";
		return query;
	};
	$scope.calculatePromotions = function(data, product) {
		console.log('data'+JSON.stringify(data)+'product'+JSON.stringify(product));
		var cond = 0;
		var action = 0;
		var quan = 0;
		for (var i = 0; i < data.length; i++) {
			var current = data[i];
			if (current.inputParamEnumId) {
				cond = $scope.processCondition(current);
			}
			if (current.productPromoActionEnumId) {
				action = $scope.getPromosResult(current);
			}
			if (cond && action) {
				if (!action.amount) {
					quan = Math.floor(product.quantity / cond) * action.quantity;
					console.log('pppp' + $scope.promotions.length  + JSON.stringify($scope.promotions));
					if (quan) {
						$scope.promotions.push({
							productId : current.acproductId,
							productName : current.acproductName,
							quantity : quan,
							unitPrice : current.acunitPrice
						});
					}
				} else {
					$scope.recalculateProductPrice(current.acproductId, action.amount);
				}
			}
		}
	};

	$scope.processCondition = function(promos) {
		var cond = 0;
		switch(promos.inputParamEnumId) {
		case "PPIP_PRODUCT_QUANT" :
			cond = promos.condValue ? parseInt(promos.condValue) : 0;
			break;
		case "PPIP_PRODUCT_TOTAL" :
			cond = promos.condValue ? parseInt(promos.condValue) : 0;
			break;
		}
		return cond;
	};
	$scope.processOperator = function(promos, input, cond) {
		var flag = false;
		var operator = promos.operatorEnumId;
		switch(promos.operatorEnumId) {
		case "PPC_GTE" :
			flag = eval();
			break;
		case "PPC_EQ" :

			break;
		}
	};
	$scope.getPromosResult = function(promos) {
		var quantity = 0;
		var amount = 0;
		var res;
		var tmp = promos.productPromoActionEnumId;
		switch(tmp) {
		case "PROMO_GWP" :
			quantity = promos.quantity ? parseInt(promos.quantity) : 0;
			res = {
				quantity : quantity
			};
			break;
		case "PROMO_PROD_DISC" :
			quantity = promos.quantity ? parseInt(promos.quantity) : 0;
			amount = promos.amount ? parseInt(promos.amount) : 0;
			res = {
				quantity : quantity,
				amount : amount
			};
			break;
		}
		console.log('abc1'+JSON.stringify(res));
		return res;
	};
	$scope.recalculateProductPrice = function(id, amount) {
		for (var x in $scope.bought) {
			if ($scope.bought[x].productId == id) {
				var oldPr = $scope.bought[x].unitPrice;
				$scope.bought[x].unitPrice = oldPr - amount * oldPr / 100;
				$scope.setOldPrice(id, $scope.bought[x].unitPrice);
				console.log("old price " + oldPr + "new price " + $scope.bought[x].unitPrice);
			}
		}
	};

	$scope.setOldPrice = function(id, price) {
		var obj = $("#price-" + id);
		obj.addClass("old-price");
		obj.append("<div class='new-price'>" + $scope.FormatNumberBy3(price) + "</div>");
	};

	$scope.calculateCartAmount = function() {
		var amount = 0;
		for (var x in $scope.bought) {
			var obj = $scope.bought[x];
			amount += obj.unitPrice * obj.quantity;
		}
		$scope.checkOrderPromotion(amount);
	};
	/* check promotions for order in local database */
	$scope.checkOrderPromotion = function(amount) {
		var query = "SELECT * FROM promotions WHERE productPromoCondSeqId IS NULL OR productPromoActionSeqId IS NULL";
		/*SqlService.select("promotions").then(function(res){
		 console.log("fucking promotions in checkorder promotions: " + JSON.stringify(res));
		 });*/
		SqlService.query(query).then(function(res) {
			var tmp = amount;
			if (res && res.length && amount) {
				tmp = $scope.processOrderPromotion(res, amount);
			}
			$("#total-amount").html($scope.FormatNumberBy3(tmp) + "đ");
		}, function() {
			$("#total-amount").html($scope.FormatNumberBy3(amount) + "đ");
		});
	};
	/* process promotions for order in local database */
	$scope.processOrderPromotion = function(data, totalPayment) {
		var target = 0;
		var targetObj;
		var total = totalPayment;
		for (var x in data) {
			var obj = data[x];
			var tmp = parseInt(obj.condValue);
			if (obj.condValue && tmp > target) {
				target = tmp;
				targetObj = obj;
			}
		}
		if (targetObj) {
			$scope.processCondition(targetObj);
			switch(targetObj.productPromoActionEnumId) {
			case "PROMO_ORDER_PERCENT":
				if (targetObj.amount) {
					var dis = total * parseInt(targetObj.amount) / 100;
					total = total - dis;
				}
				break;
			case "PROMO_ORDER_AMOUNT":
				if (targetObj.amount) {
					total = total - parseInt(targetObj.amount);
				}
			}
		}
		return total;
	};
	$scope.renderProductPromotions = function(data) {
		var str = "<tr>";
		str += "<td>" + data.productId + "</td>";
		str += "<td>" + data.productName + "</td>";
		str += "<td>" + data.quantity + "</td>";
		str += "<td>" + data.unitPrice + "</td>";
		str += "</tr>";
		return str;
	};
	// $scope.stringtoCurrency = function(input) {
	// var price = "";
	// var pr = [];
	// pr = input.split(" ");
	// price = pr[0];
	// pr = price.split(",");
	// price = "";
	// for (var x in pr) {
	// price += pr[x];
	// }
	// return parseInt(price);
	// };
	/*show notify*/
	$scope.showNotify = function(notify, status) {
		if (!status) {
			$("#notification").addClass("error-color");
		}
		$scope.notification = notify;
	};
	$scope.clearNotify = function() {
		$scope.notification = "";
		$scope.$apply();
		$("#notification").removeClass("error-color");
	};
	/*reset order*/
	$scope.viewOrder = function() {
		$location.path('order/true');
	};
	var disableContainerScroll = function() {
		$("#container").css("overflow", "hidden");
	};
	var enableContainerScroll = function() {
		$("#container").css("overflow", "");
	};
	var initModal = function() {
		var modal = $('#submitorder');
		var container = $("#container");
		modal.on('hidden.bs.modal', function() {
			$scope.clearNotify();
			$("#submitOrderBt").show();
			enableContainerScroll();
			
			$("#promotions").html("");
			$scope.promosProcessed = 0;
			// $timeout(function() {
			// container.animate({
			// scrollTop : 0
			// }, '200', 'swing');
			// }, 50);
		});
		modal.on('show.bs.modal', function() {
			$scope.clearNotify();
			container.scrollTop(0);
		});
		modal.on('shown.bs.modal', function() {
			var str = "";
			for (var x in $scope.products) {
				var product = $scope.products[x];
				if (product.quantity) {
					str += "<tr><td>" + product.productId + "</td>";
					str += "<td>" + product.productName + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.quantity) + "</td>";
					str += "<td>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
					str += "</tr>";
				}
			}
			$("#productOrderBody").html(str);
		});
	};
});
