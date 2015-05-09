/*
 * controller for create order
 * */
olbius.controller('CreateOrderController', function($rootScope, $scope, $controller, $timeout, $location, $compile,OrderService, ProductService, GPS) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	//current road selected
	$scope.notification = "";
	$scope.currentStore = null;
	$scope.currentInventory = null;
	$scope.products = [];
	$scope.pageSize = 15;
	$scope.current = 1;
	$scope.total = 0;
	$scope.PaymentTotal = "";
	$scope.checkPromo = false;
	//scope isolated
	$scope.isValidDistance = true;
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Tạo đơn hàng", "/main", false);
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
		var data = [];
		if (localStorage.products) {
			data = JSON.parse(localStorage.getItem("products"));
		} else {
			$scope.getAllProduct();
			if (localStorage.products) {
				data = JSON.parse(localStorage.getItem("products"));
			}
		}
		if (data) {
			$scope.initQuantity(data);
		}
		$scope.initProductPagination();
		generatePagination();
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
		for (var x = start; x < limit; x++) {
			var product = data[x];
			str += "<tr>";
			str += "<td>" + product.productId + "</td>";
			str += "<td>" + product.productName + "</td>";
			str += "<td style='text-align:right;'>" + $scope.FormatNumberBy3(product.unitPrice) + "</td>";
			str += "<td><input type='tel' class='number' placeholder='0' id='quantity" + product.productId + "' ng-model='products[" + x + "].quantity'/></td>";
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
		ProductService.getAll(function() {
		}).then(function(res) {
			if (res.listProduct) {
				$scope.products = res.listProduct;
				if ($scope.products.length) {
					localStorage.setItem("products", JSON.stringify(res.listProduct));
				}
			}
		}, function(res) {
			console.log("error" + JSON.stringify(res));
		});
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
	$scope.showOrder = function(){
		var str = "<input type='text'>";
		BootstrapDialog.show({
						// title : $rootScope.Map.OrderDetail[$rootScope.key],
						title : 'test',
			            // message: $rootScope.Map.RequiredSynchronizeAfterCheckInventory[$rootScope.key],
			            onshow : function(dialogRef){
			            	console.log($('a'));
			            },
			            type : BootstrapDialog.TYPE_SUCCESS,
			            closable : false,
			            spinicon : 'fa fa-spinner',
			            autodestroy : true,
			            buttons: [{
			                icon: 'glyphicon glyphicon-ok',
			                // label: $rootScope.Map.SendOrder[$rootScope.key],
			                 label: 'Gui don hang',
			                cssClass: '',
			                autospin: true,
			                action: function(dialogRef){
			                    dialogRef.enableButtons(false);
			                    dialogRef.setClosable(false);
			                    dialogRef.getModalBody().html(str);
			                    setTimeout(function(){
			                        dialogRef.close();
			                    }, 2000);
			                }
			            }, {
			            	icon : 'fa fa-ban',
			                // label: $rootScope.Map.again[$rootScope.key],
			                label: 'Cancel',
			                action: function(dialogRef){
			                    dialogRef.close();
			                }
			            }]
			        }); 
	};
	/* submit order to server
	 * input: list product id vs quantity */
	$scope.submitOrder = function() {
		var products = "";
		var renderTable = "<table class='table table-striped table-bordered table-hover products'>";
			renderTable += '<th class="center">Mã SP</th>';		
			renderTable += '<th class="center">Tên SP</th>';	
			renderTable += '<th class="center">SL</th>';	
		for (var x in $scope.products) {
			if ($scope.products[x].quantity) {
				if (x != 0) {
					products += "||";
				}
				products += $scope.products[x].productId + "%%" + $scope.products[x].quantity;
			}
		}
		if (!products) {
			$scope.showNotify("Bạn cần chọn tối thiểu 1 SP", false);
			return;
		}
		var customer = $scope.currentStore.partyIdTo;
		OrderService.submitOrder(customer, products, $rootScope.showLoading).then(function(data) {
			$scope.PaymentTotal = data.res["PaymenTotal"];
			for(var r in data.res["OrderInfo"]){
				if(typeof data.res["OrderInfo"][r].productName != "undefined"){
					renderTable += "<tr><td>" +data.res["OrderInfo"][r].productId + "</td>" ;
				}
				if(typeof data.res["OrderInfo"][r].productId != "undefined"){
					renderTable += "<td>" + data.res["OrderInfo"][r].productName +"</td>" ;
				}
				if(typeof data.res["OrderInfo"][r].productQuantity != "undefined"){
					renderTable += "<td>" + data.res["OrderInfo"][r].productQuantity + "</td></tr></table>";
				}
				$("#GiftProduct").html(renderTable);	
			}
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
				bodyOrder += renderTable;
			}
			console.log('renderTable' + renderTable);
			$scope.checkPromo = true ; 
			$rootScope.hideLoading();
			$('#submitorder').modal('hide');
			$scope.showNotify("Tạo đơn thành công", true);
			$scope.initQuantity($scope.products);
			BootstrapDialog.show({
							title : 'Tạo đơn hàng thành công',
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
			                        dialogRef.close();
				                }
				            }]
				        }); 
		}, function() {
			BootstrapDialog.show({
							title : $rootScope.Map.Notification[$rootScope.key],
				            message: $rootScope.Map.CreateOrderError[$rootScope.key],
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
				                    // dialogRef.getModalBody().html($rootScope.Map.MoveSynchronize[$rootScope.key]);
				                        dialogRef.close();
				                }
				            }]
				        }); 
		});
	};
	var bodyOrder = '';
	$scope.vl = function(){
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
	$scope.clearPaymentTotal = function (){
		$scope.PaymentTotal = 0;
		$scope.checkPromo = false ; 
		$("#GiftProduct").html("");	
		$("#productOrderBody").html("");
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
	$scope.stringtoCurrency = function(input) {
		var price = "";
		var pr = [];
		pr = input.split(" ");
		price = pr[0];
		pr = price.split(",");
		price = "";
		for (var x in pr) {
			price += pr[x];
		}
		return parseInt(price);
	};
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
	// };
	// var disableContainerScroll = function(){
		// $("#container").css("overflow","hidden");
	// };
	// var enableContainerScroll = function(){
		// $("#container").css("overflow","");
	// };  
	
	};
	var initModal = function(){
		var height = $(document).height();
		var modal = $('#submitorder');
		modal.height(height);
		var container = $("#container");
		modal.on('hidden.bs.modal', function() {
			$scope.clearNotify();
			$("#submitOrderBt").show();
			// $timeout(function(){
				// container.animate({scrollTop: 0}, '200', 'swing');
			// }, 50);
		});
		modal.on('show.bs.modal', function() {
			$scope.clearNotify();
			container.scrollTop(0);
		});
		modal.on('shown.bs.modal', function(){
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
			$("#productOrderBody").html(str);
		});
	};
});
