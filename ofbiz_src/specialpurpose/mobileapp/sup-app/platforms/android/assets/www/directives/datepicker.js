/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller: - retrieves and persists the
 * model via the todoStorage service - exposes the model to the template and
 * provides event handlers
 */
olbius
		.directive(
				'uiDatepicker',
				[
						'$compile',
						'$filter',
						function($compile, $filter) {
							function init(scope, element, attrs) {
								var jqueryElm = $(element[0]);
								$(jqueryElm).datepicker();
								scope.id = 
								$('.fk-calendar').ready(function() {
									
								});
								scope.open = function($event) {
									$event.preventDefault();
									$event.stopPropagation();
									scope.opened = true;
								};
								scope.dateOptions = {
									formatYear : 'yy',
									startingDay : 1
								};
						
								scope.$watch('dateValue', function() {
									scope.date = $filter('date')(
											scope.dateValue, 'dd-MM-yyyy');
								});
							}

							return {
								restrict : 'ACE',
								template : "<div class='row fk-calendar'><div class='col-lg-12 col-md-12 col-xs-12 col-sm-12'>"
										+ "<input type='text' class='form-control icon-calendar' datepicker-popup='dd-MM-yyyy'"
										+ "ng-model='dateValue' is-open='opened' min-date='mindate'"
										+ "datepicker-options='dateOptions' date-disabled='disabled(date, mode)'"
										+ "ng-required='true' close-text='Close' ng-click='open($event)'/>"
										+ "</div></div>",
								scope : {
									date : '=',
									mindate : '='
								},
								link : init
							};
						} ]);
