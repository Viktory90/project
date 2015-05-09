/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.controller('CustomerOpinionController', function($rootScope, $scope, $location, $controller, $compile, CustomerOpinion, CustomerService,SqlService) {
	$.extend(this, $controller('BaseController', {
		$scope : $scope
	}));

	//init Variable for get infomation FeedBack Customer
	$scope.customers = new Array();
	$scope.infoFBfromCustomer = {
		customerName : "",
		comment : "",
	};
	$scope.Flag = false;
	$scope.toCustomer = function() {
		$location.path('customer');
	};
	$scope.$on('$viewContentLoaded', function() {
		$scope.setHeader("Ý kiến khách hàng", "/main", false);
		$scope.init();
	});
	$scope.init = function() {
		$scope.getListCustomer();
		$scope.getListOpponent();
	};
	$scope.changeForm = function() {
		$scope.Flag = true;
		if ($scope.Flag) {
			$('#list1').removeClass('active');
			$('#list2').addClass('active');
			$('#infoCustomer').removeClass('active');
			$('#infoDt').addClass('active');
		}
	};
	$scope.changeFormCustomer = function() {
		$scope.Flag = false;
		if (!$scope.Flag) {
			$('#list1').addClass('active');
			$('#list2').removeClass('active');
			$('#infoCustomer').addClass('active');
			$('#infoDt').removeClass('active');
		}
	};

	$scope.getListCustomer = function() {
		var renderSelect = '';
		var currentCustomer = {};
	if($rootScope.network.status){
		CustomerService.getAll(0, 100, null).then(function(data) {
			if (data.customers && data.customers.length) {
				if (localStorage.getItem('currentCustomer')) {
					currentCustomer = $.parseJSON(localStorage.getItem('currentCustomer'));
					renderSelect += '<option value=' + currentCustomer.partyIdTo + '>' + currentCustomer.groupName + '</option>';
					for (var x in data.customers) {
						$scope.customers.push({
							groupName : data.customers[x].groupName,
							partyId : data.customers[x].partyIdTo
						});
						if (data.customers[x].partyIdTo == currentCustomer.partyIdTo) {
							var index = data.customers.indexOf(data.customers[x]);
							data.customers.splice(x, 1);
							continue;
						}
						renderSelect += '<option value=' + data.customers[x].partyIdTo + '>' + data.customers[x].groupName + '</option>';
					};
				} else {
					for (var x in data.customers) {
						renderSelect += '<option value=' + data.customers[x].partyIdTo + '>' + data.customers[x].groupName + '</option>';
					};
				};
				renderSelect += "</select>";
				$('#selectCustomer').html(renderSelect);
				$compile($('#selectCustomer').contents())($scope);
				$scope.infoFBfromCustomer.customerName = $scope.customers[0].partyIdTo;
			};
		});
	}else {
		var listCustomer = $.parseJSON(localStorage.getItem('listStore'));
		console.log('log1'+ listCustomer);
		if(listCustomer && listCustomer.length > 0){
			if (localStorage.getItem('currentCustomer')) {
					currentCustomer = $.parseJSON(localStorage.getItem('currentCustomer'));
					renderSelect += '<option value=' + currentCustomer.partyIdTo + '>' + currentCustomer.groupName + '</option>';
						for(var cus in listCustomer){
							$scope.customers.push({
										groupName : listCustomer[cus].groupName,
										partyId : listCustomer[cus].partyIdTo
									});
									if (listCustomer[cus].partyIdTo == currentCustomer.partyIdTo) {
										var index = listCustomer.indexOf(listCustomer[cus]);
											listCustomer.splice(index, 1);
										continue;
									};
								renderSelect += '<option value=' + listCustomer[cus].partyIdTo + '>' + listCustomer[cus].groupName + '</option>';		
						};
						console.log('log2' + renderSelect);
				}else {
					for(var cus in listCustomer){
						renderSelect += '<option value=' + listCustomer[cus].partyIdTo + '>' + listCustomer[cus].partyIdTo+ '</option>';
					};
					console.log('log3' + renderSelect);
				};
				renderSelect += "</select>";
				$('#selectCustomer').html(renderSelect);
				$scope.infoFBfromCustomer.customerName = $scope.customers[0].partyIdTo;
				$compile($('#selectCustomer').contents())($scope);
			};
	}	
	};
	

	$scope.submitFbCustomer = function() {
		if($rootScope.network.status){
			if ($scope.infoFBfromCustomer.customerName != '') {
				console.log($scope.infoFBfromCustomer);
				CustomerOpinion.submitFbCustomer($scope.infoFBfromCustomer).then(function(data) {
					if (data.status) {
						bootbox.alert("Gửi thông tin thành công");
					} else {
						bootbox.alert("Gửi thông tin không thành công");
					}
				});
			} else
				bootbox.alert("Hãy nhập tên khách hàng và thông tin cần gửi");
			
		}else {
			var fields = ["customerName","comment"];
			var tmp = [$scope.infoFBfromCustomer.customerName , $scope.infoFBfromCustomer.comment];
			var input = [];
			input.push(tmp);
			SqlService.insert('customerOpinion',fields,input).then(function(data){
				if(data){
					bootbox.alert('Gửi thông tin thành công');
				}
			},function(err){
				if(err) bootbox.alert("Gửi thông tin không thành công");
			});
		}	
		
	};
	//get informartion from opponent
	//init variable opponent
	$scope.opponentInfo = {
		opponentEventId : "",
		promos : "",
		otherInfo : "",
		linkImage : ""
	};
	$scope.dataOpponent = [];
	$scope.getFolder = function() {
		document.folderForm.folderLocation.value = document.folderForm.file.value;
	};
	$scope.submitInfoOpponent = function() {
		console.log($scope.opponentInfo.opponentEventId);
		if($rootScope.network.status){
			if ($scope.opponentInfo.opponentEventId != '') {
			CustomerOpinion.submitInfoOpponent($scope.opponentInfo).then(function(data) {
				if (data.status) {
					bootbox.alert("Gửi thông tin thành công");
				} else
					bootbox.alert("Gửi thông tin không thành công");
					});
			} else
				bootbox.alert("Gửi thông tin không thành công,hãy chọn tên đối thủ");
		}else {
			var fields = ["opponentEventId","promos","otherInfo","linkImage"];
			var tmp = [$scope.opponentInfo.opponentEventId,$scope.opponentInfo.promos,$scope.opponentInfo.otherInfo,$scope.opponentInfo.linkImage];
			var input = [];
			input.push(tmp);
			SqlService.insert('opponent',fields,input).then(function(data){
				if (data) {
					bootbox.alert("Gửi thông tin thành công");
				}else
					bootbox.alert("Gửi thông tin không thành công");
			},function(err){
				
			});
		}
		
	};
	$scope.getListOpponent = function() {
		var renderListOpponent = '<option value="">Chọn đối thủ...</option>';
		if($rootScope.network.status){
			CustomerOpinion.getListOpponent().then(function(data) {
			if (data.data.listOpponent && data.data.listOpponent.length) {
				for (var key in data.data.listOpponent) {
					renderListOpponent += '<option value=' + data.data.listOpponent[key].opponentEventId + '>' + data.data.listOpponent[key].opponentName + '</option>';
				}
			};
			$('#listOpponent').html(renderListOpponent);
			$compile($('#listOpponent').contents())($scope);
		});
		}else {
			if(localStorage.getItem('listOpponent')){
				var data = $.parseJSON(localStorage.getItem('listOpponent'));
			}
			console.log('list' + JSON.stringify(data));
				 if (data && data.length > 0) {
					for (var key in data) {
						renderListOpponent += '<option value=' + data[key].opponentEventId + '>' + data[key].opponentName + '</option>';
						}
				};
				$('#listOpponent').html(renderListOpponent);
				//$compile($('#listOpponent').contents())($scope);
		}
		
	};
});
