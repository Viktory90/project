/*global todomvc, angular */
'use strict';

/**
 * useful to take a photo from native camera
 */
olbius.directive('camera', ['$compile', '$cordovaCamera','$rootScope',
function($compile, $cordovaCamera,$rootScope) {
	function init(scope, element, attrs) {
		scope.takePicture = function() {
			var optionsData = {
				quality : 50,
				destinationType : Camera.DestinationType.FILE_URI,
				sourceType : Camera.PictureSourceType.CAMERA,
				allowEdit : true,
				encodingType : Camera.EncodingType.JPEG,
				targetWidth : 1024,
				targetHeight : 768,
				popoverOptions : CameraPopoverOptions,
				saveToPhotoAlbum : false,
				correctOrientation : true
			};
				$cordovaCamera.getPicture(optionsData).then(function(imageData) {
					    var image = document.getElementById('olImg');
					   // var src = imageData;
					   	log('imageData' + JSON.stringify(imageData));
					    image.src = imageData;
					    scope.image = image;
					    uploadPhoto(imageData);
					}, function(err) {
						console.log("error");
					});
					var success = function (r) {
					    console.log("Code = " + r.responseCode);
					    console.log("Response = " + r.response);
					    console.log("Sent = " + r.bytesSent);
					    console.log('result upload image' + JSON.parse(r.response).path);
						$rootScope.pathImage = JSON.parse(r.response).path;
					};
					var error = function (error) {
					    alert("An error has occurred: Code = " + error.code);
					    console.log("upload error source " + error.source);
					    console.log("upload error target " + error.target);
					};
					var uploadPhoto = function(imageData){
						var imageURI = imageData;
						var optionsUpload = new FileUploadOptions();
							optionsUpload.fileKey = "uploadedFile";
							optionsUpload.fileName = imageURI.substr(imageURI.lastIndexOf('/')+1);
							optionsUpload.mimeType = "image/jpeg";
						var params = {
								_uploadedFile_fileName : "imageCustomer",
								_uploadedFile_contentType : "image/jpeg",
								folder : "mobileimage"
						};
						optionsUpload.params = params;
						var ft = new FileTransfer();
						var trustAllHost = true;
						ft.upload(imageURI, baseUrl + '/uploadImage',success,error,optionsUpload,trustAllHost);
					};
		};
	}
	return {
		restrict : 'ACE',
		template : '<div style="display:block"><img style="width: 100%;heigth : 100%; margin : 20px 0 20px 0;" id="olImg"/></div><div id="camera" class="center"><div style="display:block"><button class="btn" ng-click="takePicture()"><i class="glyphicon glyphicon-camera"></i> Camera</button></div>',
		image : "=",
		link : init
	};
}]);
