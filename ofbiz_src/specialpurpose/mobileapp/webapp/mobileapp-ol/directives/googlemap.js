/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius.directive('googlemap', ['uiGmapGoogleMapApi', 'geolocation','uiGmapIsReady', "$timeout", 
function(GoogleMapApi, geolocation,uiGmapIsReady,$timeout) {
	function init(scope, element, attrs) {
		console.log("directive", scope.accessor);
		/* init center of map */
		element.ready(function() {
			if (scope.height) {
				$(".angular-google-map-container").height(scope.height);
			}
		});
		scope.direction = false;
		scope.googlemap = {};
		var center = {
			latitude : 0,
			longitude : 0
		};
		if (localStorage.lastLocation) {
			center = JSON.parse(localStorage.lastLocation);
		}
		scope.searchbox = {
			template : 'searchbox.tpl.html',
			position : 'top-left',
			options : {
				bounds : {
				}
			},
			events : {
				places_changed : function(searchBox) {
					var places = searchBox.getPlaces();
					if (places.length == 0) {
						return;
					}
					// For each place, get the icon, place name, and location.
					var newMarkers = [];
					var bounds = new google.maps.LatLngBounds();
					for (var i = 0, place; place = places[i]; i++) {
						// Create a marker for each place.
						var marker = {
							id : i,
							place_id : place.place_id,
							name : place.name,
							latitude : place.geometry.location.lat(),
							longitude : place.geometry.location.lng(),
							options : {
								draggable : true
							},
							templateurl : 'window.tpl.html',
							templateparameter : place
						};
						newMarkers.push(marker);
						bounds.extend(place.geometry.location);
					}

					scope.map.bounds = {
						northeast : {
							latitude : bounds.getNorthEast().lat(),
							longitude : bounds.getNorthEast().lng()
						},
						southwest : {
							latitude : bounds.getSouthWest().lat(),
							longitude : bounds.getSouthWest().lng()
						}
					};

					_.each(newMarkers, function(marker) {
						// marker.options =  {
							// draggable : true
						// };
						marker.closeClick = function() {
							scope.selected.options.visible = false;
							marker.options.visble = false;
							return scope.$apply();
						};
						marker.onClicked = function(data, res) {
							// var first = {
								// lat : scope.marker.coords.latitude,
								// lng : scope.marker.coords.longitude,
							// };
							// var mo = data.model;
							// var second = {
								// lat : mo.latitude,
								// lng : mo.longitude
							// };
							// scope.getDirections(first, second);
						};
					});

					scope.map.markers = newMarkers;
					//scope.searchbox.options.visible = false;
				}
			}
		};
		/* init map information */
		scope.map = {
			idKey: 'olbius',
			center : center,
			control : {},
			zoom : 12,
			dragging : false,
			refresh : false,
			bounds : {},
			markers : [],
		};
		/* set default marker for map */
		if (!scope.marker) {
			scope.marker = {
				id : 0,
				coords : {},
				options : {
					draggable : true
				},
				events : {
					dragend : function(marker, eventName, args) {
						scope.marker.coords.latitude = args.coords.latitude;
						scope.marker.coords.longitude = args.coords.longitude;
					}
				}
			};
			console.log(scope.marker + 'markerrrr');
		}
	
		scope.$parent.focus = function(lat, long) {
			console.log('into focus');
			var location = {
				latitude : lat,
				longitude : long
			};
			localStorage.setItem('lastLocation', JSON.stringify(location));
			scope.marker.coords = location;
			if (scope.$parent.customer) {
				scope.customer.latitude = lat;
				scope.customer.longitude = long;
			}
			if (scope.map.control.refresh) {
				scope.map.control.refresh(location);
			}
		};

		geolocation.getLocation().then(function(data) {

			scope.$parent.focus(data.coords.latitude, data.coords.longitude);
		}, function(res) {
			alert("Please turn on your GPS!");
		});
		/* bind event on maps loaded */
		GoogleMapApi.then(function(maps) {
			scope.googleVersion = maps.version;
			scope.googlemap = maps;
			maps.visualRefresh = true;
			scope.directionsDisplay = new maps.DirectionsRenderer();
			scope.directionsService = new maps.DirectionsService();
			scope.geocoder = new maps.Geocoder();
			scope.defaultBounds = new google.maps.LatLngBounds(new google.maps.LatLng(40.82148, -73.66450), new google.maps.LatLng(40.66541, -74.31715));
			scope.map.bounds = {
				northeast : {
					latitude : scope.defaultBounds.getNorthEast().lat(),
					longitude : scope.defaultBounds.getNorthEast().lng()
				},
				southwest : {
					latitude : scope.defaultBounds.getSouthWest().lat(),
					longitude : -scope.defaultBounds.getSouthWest().lng()
				}
			};
			scope.searchbox.options.bounds = new google.maps.LatLngBounds(scope.defaultBounds.getNorthEast(), scope.defaultBounds.getSouthWest());
		});
		scope.getDirections = function(origin, destination) {
			var request = {
				origin : new scope.googlemap.LatLng(origin.lat, origin.lng),
				destination : new scope.googlemap.LatLng(destination.lat, destination.lng),
				travelMode : scope.googlemap.DirectionsTravelMode.DRIVING
			};
			scope.directionsService.route(request, function(response, status) {
				if (status === scope.googlemap.DirectionsStatus.OK) {
					scope.directionsDisplay.setDirections(response);
					scope.directionsDisplay.setMap(scope.map.control.getGMap());
					scope.directionsDisplay.setPanel(document.getElementById('directionsList'));
					$("#distance").html(response.routes[0].legs[0].distance.text);
					$("#duration").html(response.routes[0].legs[0].duration.text);
					scope.direction = true;
				} else {
					bootbox.alert('Google route unsuccesfull!');
				}
			});
		};
		
		scope.$parent.setMarkers = function(data){
			console.log(data);
			scope.markers = [];
			$timeout(function() {
				scope.map.markers = data;
			}, 500);
		};
		// scope.$parent.setMarkers = function(data) {
// 			
		// };
		scope.$parent.getMarkerPoint = function() {
			return {
				latitude : scope.marker.coords.latitude,
				longitude : scope.marker.coords.longitude,
			};
		};

		scope.onClicked = function(res, event, data) {
			BootstrapDialog.show({
								title : 'Thông báo',
					            message: "Chỉ đường tới đây?",
					            type : BootstrapDialog.TYPE_WARNING,
					            closable : true,
					            spinicon : 'fa fa-spinner',
					            buttons: [{
					                icon: 'glyphicon glyphicon-ok',
					                label: 'Ok',
					                cssClass: 'btn-primary',
					                autospin: true,
					                action: function(dialogRef){
					                    dialogRef.enableButtons(false);
					                    dialogRef.setClosable(false);
					                    var first = {
												lat : scope.marker.coords.latitude,
												lng : scope.marker.coords.longitude,
											};
											var second = {
												lat : data.latitude,
												lng : data.longitude
											};
											scope.$parent.PointSelected = second;
											scope.getDirections(first, second);
				                       		 dialogRef.close();
					                }
					            },{
					            	icon : 'fa fa-times',
					            	label : 'cancel',
					            	autospin : true,
					            	action : function(dialogRef){
					            		dialogRef.close();
					            	}
					            }]
					        }); 
		};
		scope.onMarkerClicked = function(data) {
			var point = data.coords;
			scope.onClicked(null, null, point);
		};
		
	}

	return {
		templateUrl : 'templates/item/googlemap.htm',
		restrict : 'ACE',

		// transclude: true,
		scope :{
			marker : '=',
			store : '=',
			height : '='
		},

		link : init
	};
}]);
