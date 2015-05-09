/*global todomvc, angular */
'use strict';

/**
 * useful to take a photo from native camera
 */
olbius.directive('camera', ['$compile', '$cordovaCamera',
function($compile, $cordovaCamera) {
	function init(scope, element, attrs) {
		scope.takePicture = function() {
			var options = {
				quality : 75,
				destinationType : Camera.DestinationType.DATA_URL,
				sourceType : Camera.PictureSourceType.CAMERA,
				allowEdit : true,
				encodingType : Camera.EncodingType.JPEG,
				targetWidth : 1024,
				targetHeight : 768,
				popoverOptions : CameraPopoverOptions,
				saveToPhotoAlbum : false
			};
			console.log('vao camera');
			$cordovaCamera.getPicture(options).then(function(imageData) {
				console.log('lay anh');
			    var image = document.getElementById('olImg');
			    var src = "data:image/jpeg;base64," + imageData;
			    image.src = src;
			    scope.image = src;
			}, function(err) {
				console.log("error");
			});
		};
	}

	return {
		restrict : 'ACE',
		template : '<div id="camera" class="center"><button class="btn" ng-click="takePicture()"><i class="glyphicon glyphicon-camera"></i> Camera</button><img style="width: 300px; margin-top: 15px;" id="olImg"/></div>',
		image : "=",
		link : init
	};
}]);
