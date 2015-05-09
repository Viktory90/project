/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.controller('ProfileController', function($rootScope, $scope, $controller,CustomerService,AuthService) {
    $.extend(this, $controller('BaseController', {
        $scope: $scope
    }));
    $scope.options = {
        url: baseUrl + 'editAvatarSalesman'
    };
    $scope.$on('$viewContentLoaded',function(){
    	$scope.setHeader('ProfileSalesMan', "/main", false);
    	$scope.inIt();
    });
    $scope.inIt = function(){
    	$scope.getInfo();
    	initModal();
    };
     $scope.password = {
    	CurrentPassword : "",
    	NewPassword : "",
    	PasswordVerify : "",
    	check : false,
    	status : {
    		success : false,
    		error : false,
    		notify : false
    	},
    	login : false,
    };
    $scope.credentials = {
		USERNAME : '',
		PASSWORD : ''
	};
	$scope.login = function() {
		var username = $scope.credentials.USERNAME;
		var password = $scope.credentials.PASSWORD;
		var userCurrent = {};
		if(localStorage.getItem('UserInfo')){
			userCurrent = $.parseJSON(localStorage.getItem('UserInfo'));
		}
		if(userCurrent){
			if(userCurrent.USERNAME == username){
				if(userCurrent.PASSWORD == password){
					$rootScope.showLoading();
					$scope.credentials = {
						USERNAME : username.toLowerCase(),
						PASSWORD : password.toLowerCase()
					};
					AuthService.login($scope.credentials).then(function(res) {
						if (res._LOGIN_PASSED_) {
							$rootScope.hideLoading();
							$scope.password.login = true;
							$('#changePasswdForm').trigger('reset');
							$rootScope.openDialog($rootScope.Map.LoginSuccess[$rootScope.key]);
						} else {
							$scope.password.login = false;
							$rootScope.hideLoading();
							$rootScope.openDialog($rootScope.Map.LoginFailed[$rootScope.key]);
						}
					}, function() {
						$scope.password.login = false;
						$rootScope.hideLoading();
						$rootScope.openDialog($rootScope.Map.LoginFailed[$rootScope.key]);
					});
				}else $rootScope.openDialog($rootScope.Map.PasswordInvalid[$rootScope.key]);
			}else $rootScope.openDialog($rootScope.Map.NotiChangePassword[$rootScope.key]);
		}
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
    var initModal = function(){
    	var modal = $('#myModal');
    	modal.on('hidden.bs.modal',function(){
    		$('#changePasswdForm').trigger('reset');
    		});
    };
     $scope.edit = {
    	checkEdit : false
    };
    $scope.checkEdit = function(){
    	$scope.edit.checkEdit = true;
    };
    $scope.updatePassword = function(){
    		$('#changePasswdForm').trigger('reset');
		    if($scope.password.CurrentPassword != $scope.credentials.PASSWORD){
		    	$scope.password.status.notify = true;
		    	alert('Mat khau hien tai khong chinh xac!');
		    }	
		    else if($scope.password.NewPassword != $scope.password.PasswordVerify){
		    	$scope.password.check = true;
		    }else if(!$scope.password.NewPassword || !$scope.password.PasswordVerify || !$scope.password.CurrentPassword){
		    	// $scope.password.status.notity = true;
		    }
		    else {
		    	$scope.password.status.notity = false;
		    			AuthService.updatePasswordSalesMan($scope.password,$rootScope.showLoading).then(function(data){
		    			$rootScope.hideLoading();
		    			if(data._ERROR_MESSAGE_){
		    				$scope.password.check = false;
		    				$scope.password.status.error = true;
		    				$scope.password.status.success = false;
		    			}else {
		    				$scope.password.status.success = true;
		    				$scope.password.status.error = false;
		    				$scope.password.check = false;
		    			} 
		    		},function(err){
							$scope.password.status.error = true;   
							$scope.password.status.success = false;			
		    		});
		    }	
    	
    };
    $scope.infoSalesMan = {
    };
    $scope.infoName = "";
    $scope.changeName = function(){
    	$scope.info.firstName = "";
    	$scope.info.middleName = "";
    	$scope.info.lastName = "";
    	$scope.infoSalesMan.firstName = "";
    	$scope.infoSalesMan.middleName = "";
    	$scope.infoSalesMan.lastName = "";
    	var name = $scope.infoName.split(' ');
    	if(!$scope.infoName || !$scope.infoSalesMan.address){
    		$rootScope.openDialog($rootScope.Map.NotiPressFullInfo[$rootScope.key]);
    	}
    	else if(name.length == 1){
    		$scope.info.firstName = name[0];
    		$scope.info.lastName = '  ';
    	}
    	else if(name.length == 2 ) {
    		$scope.info.firstName = name[0];
    		$scope.info.lastName = name[1];
    	}else if (name.length == 3) {
    		$scope.info.firstName = name[0];
    		$scope.info.middleName = name[1];
    		$scope.info.lastName = name[2];
    	}else {
    		$scope.info.firstName  = name[0];
    		for(var i = 1 ;i<name.length -1;i++){
    			$scope.info.middleName += name[i];
    		}
    		$scope.info.lastName  = name[name.length - 1 ];
    	}
    	$scope.infoSalesMan.firstName = $scope.info.firstName;
    	$scope.infoSalesMan.middleName = $scope.info.middleName;
    	$scope.infoSalesMan.lastName = $scope.info.lastName;
    	
    };
    $scope.info = {} ; 
    $scope.getInfo = function(){
    	 var account = {};
    	if(localStorage.getItem('employee'))  $scope.info = $.parseJSON(localStorage.getItem('employee'));
    	if(localStorage.getItem('UserInfo'))  account = $.parseJSON(localStorage.getItem('UserInfo'));
    	$scope.infoName = $scope.info.firstName + ' ' + $scope.info.middleName + ' ' + $scope.info.lastName;
    	CustomerService.getInfoSalesMan($rootScope.showLoading).then(function(data){
    		if(data){
    			$rootScope.hideLoading();
    			$scope.infoSalesMan = 
    				{
						address : data.listInfo[0].address1,
						city : data.listInfo[0].city,
						stateProvinceGeoId : data.listInfo[0].stateProvinceGeoId,
						fromDate : formatDateYMD(data.listInfo[0].fromDate.time),
						lastUpdate : formatDateYMD(data.listInfo[0].lastUpdatedStamp.time),
						contactMechId : data.listInfo[0].contactMechId,
						firstName : data.listInfo[0].firstName,
						middleName : data.listInfo[0].middleName,
						lastName : data.listInfo[0].lastName,
			    		userLogin : account.USERNAME,
						password : account.PASSWORD , 
						createdDate : $scope.info.createdTxStamp 	
    				};
    		}
    	},function(err){
    		$rootScope.hideLoading();
    		console.log('error get list salesman');
    	});
    	
    };	
    $scope.cancel = function(){
    	$scope.edit.checkEdit = false;
    	$scope.password = {
	    	CurrentPassword : "",
	    	NewPassword : "",
	    	PasswordVerify : "",
	    	check : false,
	    	status : {
	    		success : false,
	    		error : false,
	    		notify : false
	    	},
	    	login : false,
   		 };
    	$('#changePasswdForm').trigger('reset');
    };
    $scope.updateSalesMan = function(){
    	if($rootScope.network.status){
    		$scope.changeName();
	    	$scope.edit.checkEdit = false;
	    		CustomerService.updateSalesMan($scope.infoSalesMan,$rootScope.showLoading).then(function(data){
	    			$rootScope.hideLoading();
	    			if(data._ERROR_MESSAGE_){
	    				$rootScope.openDialog($rootScope.Map.UpdateInfoError[$rootScope.key]);
	    			}else{
	    				$rootScope.rootInfo = $scope.infoSalesMan;
	    				$rootScope.openDialog($rootScope.Map.UpdateInfoSuccess[$rootScope.key]);
	    			} 
		    	},function(err){
		    		$rootScope.openDialog($rootScope.Map.UpdateInfoError[$rootScope.key]);
		    	});
    	}else {
    		$rootScope.openDialog($rootScope.Map.FunctionForNetwork[$rootScope.key]);
    	}
    	
    };
});
