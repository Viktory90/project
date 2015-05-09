'use strict'

olbius.controller('routeController',function($rootScope,$scope , $controller,$route ,Route){
	$.extend(this,$controller('BaseController',{
		$scope : $scope
	}));
	/*listen view loaded */
	$scope.$on('$viewContentLoaded',function(){
		$scope.setHeader('Quản lý tuyến đường','/route',false);	
		$scope.inIt();
	});
	$scope.inIt = function(){
		$scope.getListRouteAndSalesMan();
	};
	$scope.data = {
		currentRoute : '',
		routeName  : '',
		select : [],
		listSalesMan : {},
		listRoute : {},
	};
	$scope.obj = {
		customers : [],
		salesman : [],
		listRoute : [],
		listAvaiable : [],
		listAssign : [],
		listAssignStore : []
	};
	/*change Tab*/
	$scope.changeTab = function(index,link){
		$('#list'+ index).addClass('active');
		$('#'+link).addClass('active');
		console.log(index + ' ' + link);
		
		if(index == 1){
			$('#list2').removeClass('active');
			$('#sectionB').removeClass('active');
			$('#list3').removeClass('active');
			$('#sectionC').removeClass('active');
		}else if(index == 2){
			$('#list1').removeClass('active');
			$('#sectionA').removeClass('active');
			$('#list3').removeClass('active');
			$('#sectionC').removeClass('active');
		}else if(index == 3){
			$('#list1').removeClass('active');
			$('#sectionA').removeClass('active');
			$('#list2').removeClass('active');
			$('#sectionB').removeClass('active');
		}
	};
	/*create route for salesman*/
	$scope.createRoute = function(){
			if($scope.data.select && $scope.data.select.length > 0){
				for(var i = 0;i<$scope.data.select.length;i++){
					if($scope.data.select[i] == '#'){
						var index = $scope.data.select.indexOf($scope.data.select[i]);
						$scope.data.select.splice(index,1);
					}
				}
			}
		if(!$scope.data.routeName || $scope.data.select.length <= 0){
			$rootScope.openDialog('Hãy nhập đủ thông tin trước khi tạo');
		}else{
			if(($scope.data.currentRoute != $scope.data.routeName)){
				Route.createRoute($scope.data,$rootScope.showLoading).then(function(data){
					$scope.data.select = new Array();
				if(data._ERROR_MESSAGE_){
					$rootScope.openDialog('Tạo tuyến không thành công');
				}else {
					$scope.data.currentRoute = $scope.data.routeName;
					$rootScope.hideLoading();
					$rootScope.openDialog('Tạo tuyến thành công');}	
				},function(err){
					$rootScope.openDialog('Tạo tuyến không thành công');
					console.log('error' + JSON.stringify(err));
				});
			}else {
				$rootScope.openDialog('Tuyến hiện tại đã được tạo!');
			}
		}
			
			
	};
	/*reset form*/
	$scope.cancel = function(){
		$route.reload();
	};
	$scope.submitRoute = function(distributor){
		var tmp = [];
		if(distributor == 'SalesMan'){
			$scope.changeTab(1,'route');
			for(var i = 0 ;i<$scope.obj.salesman.length ;i++){
			if($scope.obj.salesman[i].routeId){
					tmp.push($scope.obj.salesman[i]);
				}
			}
			Route.distributionRouteSalesMan(tmp,$rootScope.showLoading).then(function(data){
				$rootScope.hideLoading();
				if(data.data._ERROR_MESSAGE_){
					$rootScope.openDialog('Phân tuyến không thành công');
				}else {
					$route.reload();
					$rootScope.openDialog('Phân tuyến thành công');
					$scope.obj.listAssign = data.data.result;
					console.log($scope.obj.listAssign);
				}
			},function(err){
				$rootScope.hideLoading();
				$rootScope.openDialog('Phân tuyến không thành công');
			});
		}else if(distributor == 'Customer'){
			$scope.changeTab(3,'routeStore');
			$('#routeStore').addClass('active');
			$('#route').removeClass('active');
			$('#list1').removeClass('active');
			$('#list3').addClass('active');
			for(var i = 0 ;i<$scope.obj.customers.length ;i++){
			if($scope.obj.customers[i].routeId){
					tmp.push($scope.obj.customers[i]);
				}
			}
			Route.distributionRouteStores(tmp,$rootScope.showLoading).then(function(data){
				$rootScope.hideLoading();
				if(data.data._ERROR_MESSAGE_){
					$rootScope.openDialog('Phân tuyến không thành công');
				}else {
					$route.reload();
					$rootScope.openDialog('Phân tuyến thành công');
					$scope.obj.listAssignStore = data.data.result;
				}
			},function(err){
				$rootScope.hideLoading();
				$rootScope.openDialog('Phân tuyến không thành công');
			});
		}
		
	};
	var getIndex = function(element,array){
		return array.indexOf(element);
	};
	$scope.flag  = {
		checkRouteSalesMan : false,
		checkRouteStore : false
	};
	$scope.$watch('obj.salesman',function(){
		var model = $scope.obj.salesman;
		var _assign = [];
		var assign = $scope.obj.listAssign;
		var index = {
			salesman : [],
			assign : 0,
			temp : 0,
			check : false
		};
		for(var i = 0;i < model.length;i++){
			if(assign && assign.length > 0){
					for(var j = 0 ;j < assign.length;j++){
						if((model[i].routeId == assign[j].routeId)&&(model[i].partyId == assign[j].partyId)){
								index.salesman.push(i);
						}
						// console.log(model[i].partyId + 'vs' + assign[j].partyId);
						if((model[i].partyId != assign[j].partyId)){
							if(!_.contains(_assign,model[i])){
								_assign.push(model[i]);	
							}
						}
						if((model[i].routeId == assign[j].routeId)&&(model[i].partyId != assign[j].partyId)){
							index.check = true;
							index.assign = i;
							index.temp = j;
							BootstrapDialog.show({
								title : 'Thông báo',
					            message: 'Tuyến đường này đã được phân cho nhân viên <b>' + assign[j].partyId + '</b> ,Bạn có chắc muốn thay đổi không?',
					            type : BootstrapDialog.TYPE_WARNING,
					            closable : false,
					            spinicon : 'fa fa-spinner',
					            buttons: [{
					                icon: 'glyphicon glyphicon-ok',
					                label: 'Ok',
					                cssClass: 'btn-primary',
					                autospin: true,
					                action: function(dialogRef){
					                    dialogRef.enableButtons(false);
					                    dialogRef.setClosable(false);
					                    for(var i = 0;i<index.salesman.length;i++){
					                    	if($scope.obj.salesman[index.assign].routeId == $scope.obj.salesman[index.salesman[i]].routeId){
					                    		assign[index.temp] = {
					                    			partyId : $scope.obj.salesman[index.assign].partyId,
					                    			routeId : $scope.obj.salesman[index.assign].routeId
					                    		};
					                    		$scope.obj.salesman[index.salesman[i]].routeId = null;
					                    		$scope.$apply();
					                    	}
					                    }
				                        dialogRef.close();
					                }
					            },{
					            	icon : 'fa fa-times',
					            	label : 'Cancel',
					            	action : function(dialogRef){
					            		 for(var i = 0;i<index.salesman.length;i++){
					                    	if($scope.obj.salesman[index.assign].routeId == $scope.obj.salesman[index.salesman[i]].routeId){
					                    		$scope.obj.salesman[index.assign].routeId = null;
					                    		$scope.$apply();
					                    	}
					                    }
					            		dialogRef.close();
					            	}
					            }]
					        }); 
						}else index.check = false;
				}
			}else{
				_assign.push(model[i]);	
			}
		}
		//check list when salesman not assign
		if(index.check){
			var tmp = [];
				for(var i = 0 ; i < _assign.length ; i++){
					if(_assign[i].routeId){
						tmp.push(_assign[i]);
					}
				}
				console.log(JSON.stringify(_.pluck(tmp,'routeId')) +' || ' +JSON.stringify(_.uniq(_.pluck(tmp,'routeId'))));
				if(_.pluck(tmp,'routeId').length != _.uniq(_.pluck(tmp,'routeId')).length){
					$scope.flag.checkRouteSalesMan = true;
					BootstrapDialog.show({
											title : 'Thông báo',
								            message: 'Không thể phân 1 tuyến đường cùng lúc với nhiều nhân viên!',
								            type : BootstrapDialog.TYPE_WARNING,
								            closable : false,
								            spinicon : 'fa fa-spinner',
								            buttons: [{
								                icon: 'glyphicon glyphicon-ok',
								                label: 'Ok',
								                cssClass: 'btn-primary',
								                autospin: true,
								                action: function(dialogRef){
								                    dialogRef.enableButtons(false);
								                    dialogRef.setClosable(false);
							                        dialogRef.close();
								                }
								            }]
								        }); 
				}else $scope.flag.checkRouteSalesMan = false;
		}
	}, true);
	
	// $scope.$watch('obj.customers',function(){
		// console.log(JSON.stringify($scope.obj.listAssignStore));
		// var model = $scope.obj.customers;
		// var assign = $scope.obj.listAssignStore;
		// var _assign = [];
		// var index = {
			// customers : [],
			// assign : 0,
			// temp : 0
		// };
		// for(var i = 0;i < model.length;i++){
			// if(assign && assign.length > 0){
				// for(var j = 0 ;j < assign.length;j++){
					// if((model[i].routeId == assign[j].routeId)&&(model[i].partyId == assign[j].partyId)){
						// index.customers.push(i);
					// }
// 					
					// if(model[i].partyId != assign[j].partyId){
						// if(!_.contains(_assign,model[i])){
							// _assign.push(model[i]);
						// }	
					// }
// 					
					// if((model[i].routeId == assign[j].routeId)&&(model[i].partyId != assign[j].partyId)){
						// index.assign = i;
						// index.temp = j;
						// BootstrapDialog.show({
							// title : 'Thông báo',
				            // message: 'Tuyến đường này đã được phân cho khách hàng <b>' + assign[j].partyId + '</b> ,Bạn có chắc muốn thay đổi không?',
				            // type : BootstrapDialog.TYPE_WARNING,
				            // closable : false,
				            // spinicon : 'fa fa-spinner',
				            // buttons: [{
				                // icon: 'glyphicon glyphicon-ok',
				                // label: 'Ok',
				                // cssClass: 'btn-primary',
				                // autospin: true,
				                // action: function(dialogRef){
				                    // dialogRef.enableButtons(false);
				                    // dialogRef.setClosable(false);
				                    // for(var i = 0;i<index.customers.length;i++){
				                    	// if($scope.obj.customers[index.assign].routeId == $scope.obj.customers[index.customers[i]].routeId){
				                    		// assign[index.temp] = {
				                    			// partyId : $scope.obj.customers[index.assign].partyId,
				                    			// routeId : $scope.obj.customers[index.assign].routeId
				                    		// };
				                    		// $scope.obj.customers[index.customers[i]].routeId = null;
				                    		// $scope.$apply();
				                    	// }
				                    // }
			                        // dialogRef.close();
				                // }
				            // },{
				            	// icon : 'fa fa-times',
				            	// label : 'Cancel',
				            	// action : function(dialogRef){
				            		 // for(var i = 0;i<index.customers.length;i++){
				                    	// if($scope.obj.customers[index.assign].routeId == $scope.obj.customers[index.customers[i]].routeId){
				                    		// $scope.obj.customers[index.assign].routeId = null;
				                    		// $scope.$apply();
				                    	// }
				                    // }
				            		// dialogRef.close();
				            	// }
				            // }]
				        // }); 
					// }
				// }
			// }else{
				// _assign.push(model[i]);
			// }
		// }
		// //check list customers not contain route assigned
			// var temp = [];
				// for(var i = 0 ;i < _assign.length;i++){
					// if(_assign[i].routeId){
						// temp.push(_assign[i]);
					// }
				// }
				// if(_.pluck(temp,'routeId').length != _.uniq(_.pluck(temp,'routeId')).length){
					// $scope.flag.checkRouteStore = true;
					// BootstrapDialog.show({
								// title : 'Thông báo',
					            // message: 'Không thể phân 1 tuyến đường cùng lúc với nhiều cửa hàng!',
					            // type : BootstrapDialog.TYPE_WARNING,
					            // closable : false,
					            // spinicon : 'fa fa-spinner',
					            // buttons: [{
					                // icon: 'glyphicon glyphicon-ok',
					                // label: 'Ok',
					                // cssClass: 'btn-primary',
					                // autospin: true,
					                // action: function(dialogRef){
					                    // dialogRef.enableButtons(false);
					                    // dialogRef.setClosable(false);
				                        // dialogRef.close();
					                // }
					            // }]
					        // }); 
					// }else  $scope.flag.checkRouteStore = false;
	// },true);
	
	/*get List Route And SalesMan*/
	$scope.getListRouteAndSalesMan = function(){
		Route.getListRouteAndSalesMan($rootScope.showLoading).then(function(data){
					$rootScope.hideLoading();
					$scope.data.listRoute = data.data.result.listRoute;
					//merge list all salesman with salesman contain route
					$scope.obj.salesman  = data.data.result.listSalesMan;
					$scope.obj.customers = data.data.result.listCustomer;
					$scope.obj.listAssign = data.data.result.listDistribution;
					$scope.obj.listAssignStore = data.data.result.listDistributionCustomers;
					for(var i = 0 ; i < $scope.obj.salesman.length ; i++){
							var name = '';
							var firstName = $scope.obj.salesman[i].firstName ? $scope.obj.salesman[i].firstName : "";
							var middleName = $scope.obj.salesman[i].middleName ? $scope.obj.salesman[i].middleName : "";
							var lastName = $scope.obj.salesman[i].lastName ? $scope.obj.salesman[i].lastName : "";
							name = firstName + ' ' + middleName + ' '  + lastName;
							$scope.obj.salesman[i] = {
										partyId : $scope.obj.salesman[i].partyId,
										name : name
									};
							if($scope.obj.listAssign && $scope.obj.listAssign.length > 0){//check listAssing existed
								for(var j = 0; j < $scope.obj.listAssign.length ; j++){
									if($scope.obj.salesman[i].partyId  == $scope.obj.listAssign[j].partyIdFrom){
										$scope.obj.listAssign[j] = {
											partyId : $scope.obj.listAssign[j].partyIdFrom,
											routeId : $scope.obj.listAssign[j].partyIdTo,
											index : i
										};
										$scope.obj.salesman[i] = {
											partyId : $scope.obj.listAssign[j].partyId,
											routeId : $scope.obj.listAssign[j].routeId,
											name : name,
										};
									}
								}
							}
						}
						//merge list customers with list customers contains route
						for(var i = 0 ; i < $scope.obj.customers.length ; i++){
							$scope.obj.customers[i] = {
										partyId : $scope.obj.customers[i].partyId,
										name :  $scope.obj.customers[i].groupName
									};
							if($scope.obj.listAssignStore && $scope.obj.listAssignStore.length > 0){
								for(var j = 0; j < $scope.obj.listAssignStore.length ; j++){
									if($scope.obj.customers[i].partyId  == $scope.obj.listAssignStore[j].partyIdTo){
										$scope.obj.listAssignStore[j] = {
											partyId : $scope.obj.listAssignStore[j].partyIdTo,
											routeId : $scope.obj.listAssignStore[j].partyIdFrom,
										};
										$scope.obj.customers[i] = {
											partyId : $scope.obj.listAssignStore[j].partyId,
											routeId : $scope.obj.listAssignStore[j].routeId,
											name : $scope.obj.customers[i].name,
										};
									}
								}
							}			
						}
						// console.log('11' + JSON.stringify($scope.obj.customers));
		},function(){
			
		});
	};
	
});
