/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('DashboardController', function($rootScope, $scope, $location, $controller, DashboardServices) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));
	// init variable
	$scope.chartSeries = [];
	$scope.dataOrderDetail = {};
	$scope.dataPolicysDetail = [];
	$scope.dataProduct = [];
	var month = new Array();
	var orderAmount = new Array();
	var orderAmountTotal = 0;
	var orderAmountPercent = new Array();
	var bestCust = new Array();
	var productPurchaseArr = new Array();
	var productQuantity = new Array();
	var temp = new Array();
	var tmp = Array();
	// Config Highchart Draw
	$scope.chartConfig = {
		options : {
			chart : {
				type : 'bar',
				borderColor : '#EBBA95',
				borderWidth : 3,
				height : 300,
				width : 500,
			}
		},
		series : $scope.chartSeries,
		title : {
			text : 'Olbius DashBoard'
		}
	};
	$scope.chartConfig1 = {
		options : {
			chart : {
				type : 'column',
				borderColor : '#EBBA95',
				borderWidth : 3,
				height : 220,
				width : 500,
				options3d : {
					enabled : true,
					alpha : 15,
					beta : 15,
					depth : 50
				}
			},
			plotOptions : {
				series : {
					dataLabels : {
						enabled : true,
						format : '{y} %',
						style : {
							fontWeight : 'bold'
						},
						borderRadius : 5,
						backgroundColor : 'rgba(252, 255, 197, 0.7)',
						borderWidth : 1,
						borderColor : '#AAA',

					}
				}
			}
		},

		series : orderAmountPercent,
		xAxis : {
			opposite : true
		},
		title : {
			text : 'Olbius DashBoard'
		}
	};
	$scope.chartConfig2 = {
		options : {
			chart : {
				type : 'pie',
				plotBackgroundColor : null,
				plotBorderWidth : null,
				plotShadow : false,
				options3d : {
					enabled : true,
					alpha : 15,
					beta : 15,
					depth : 50
				}
			},
			plotOptions : {
				pie : {
					dataLabels : {
						enabled : false
					},
					showInLegend : true
				}
			}
		},
		series : [{
			data : bestCust
		}],
		title : {
			text : 'Olbius DashBoard'
		}
	};

	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Thống kê", "/main", false);
		init();
	});
	var init = function() {
		$scope.updatePopuLarProduct("thisMonth");

	};
	$scope.CurrentCustomer = null;
	// $scope.PromotionStore();
	$scope.$watch('DashboardOrder', function() {
		$scope.reportProduct();
		$scope.orderAmountPerMonth();
		$scope.customerSumAmount();
		$scope.updatePopuLarProduct();
	});

	$scope.reportProduct = function() {
		$scope.CurrentCustomer = JSON.parse(localStorage.getItem("currentCustomer"));
		DashboardServices.purchaseReportProduct($scope.CurrentCustomer.partyIdTo).then(function(res) {

			var i = 0;
			// index
			var sum = 0;
			for (var productReport in res["quantityIfo"]) {
				var quantity = parseFloat(res["quantityIfo"][productReport]["quantity"]);
				productPurchaseArr.push(quantity);
				sum += quantity;
				temp.push(productReport);
				i++;
			}

			for (var j = 0; j < productPurchaseArr.length; j++) {
				productQuantity.push(((productPurchaseArr[j] / sum * 100).toFixed(2)) / 1);
				$scope.chartSeries.push({
					name : temp[j],
					data : [productQuantity[j]]
				});
			}
			console.log('$scope.chartSeries' 
					 + JSON.stringify($scope.chartSeries));
			// console.log('log',$scope.chartConfig.series);
		});

	};

	$scope.orderAmountPerMonth = function() {
		DashboardServices.orderAmountPerMonth().then(function(res) {
			$scope.dataOrderDetail = {
				"dayOrder" : res["dayOrder"],
				"dayComplete" : res["dayComplete"],
				"dayApprove" : res["dayApprove"],
				"dayCancelled" : res["dayCancelled"],
				"waitingPayment" : res["waitingPayment"],
				"waitingComplete" : res["waitingComplete"]
			};
			for (var amount in res["monthAmount"]) {
				orderAmount.push({
					"name" : amount,
					"data" : res["monthAmount"][amount]
				});
				orderAmountTotal += res["monthAmount"][amount];
			}
			for (var order in orderAmount) {
				orderAmountPercent.push({
					"name" : orderAmount[order]["name"],
					"data" : [((orderAmount[order]["data"] / orderAmountTotal * 100).toFixed(2)) / 1]
				});
			}
		});
	};

	$scope.getPolicySalesMan = function() {
		DashboardServices.getPolicySalesMan().then(function(res) {
			console.log('res', res);
			for (var pol in res["Policys"])
			$scope.dataPolicysDetail.push(res["Policys"][pol]);
		});
	};
	$scope.customerSumAmount = function() {
		DashboardServices.customerSumAmount().then(function(res) {
			for (var r in res["bestCus"]) {
				bestCust.push([r, res["bestCus"][r]]);
			}
		});
	};
	$scope.updatePopuLarProduct = function(month) {
		if (month == 'thisMonth') {
			$("#dashboard_monthBtn").text("Tháng này");
			$("#dashboard_liLastMonth").removeClass("active");
			$("#dashboard_liThisMonth").addClass("active");
		} else {
			$("#dashboard_monthBtn").text("Tháng trước");
			$("#dashboard_liThisMonth").removeClass("active");
			$("#dashboard_liLastMonth").addClass("active");
		}
		DashboardServices.productSalesSum(month).then(function(res) {
			$("#table_bug_report > tbody tr").remove();
			var i = 0;
			for (var r in res["bestProduct"]) {
				if (i > 4) {
					break;
				}
				$scope.dataProduct.push({
					"productReport" : r,
					"quantity" : res["bestProduct"][r]
				});
				i++;
			}
		});
	};
	$scope.viewDetailOrder = function() {
		$location.path('/order/false');
	};
});
