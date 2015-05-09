/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('jqtable', ['$compile',
function($compile) {
	function init(scope, element, attrs) {
		scope.table = $('#grid-table');
		scope.current = 0;
		scope.bindPaging = false;
		scope.$watch('tblConfig', function() {
			if (scope.tblConfig && JSON.stringify(scope.tblConfig) !== "{}") {
				scope.table.jqGrid({
					datatype : "local",
					height : 'auto',
					colNames : scope.tblConfig.colName,
					colModel : scope.tblConfig.colModel,
					viewrecords : true,
					rowNum : config.pageSize,
					rowList : [config.pageSize],
					pager : '#grid-pager',
					altRows : true,
					multiselect : false,
					multiboxonly : true,
					loadComplete : function() {
						if (scope.tblConfig.colModel && scope.tblConfig.colModel[0].name === "act") {
							var ids = scope.getListId();
							var table = scope.table;
							var del = "";
							for (var i = 0; i < ids.length; i++) {
								del = "<button class='btn btn-small btn-sm-action' data-toggle='button' type='button' ng-click=\"deleteRow('" + ids[i] + "');\"><i class=\"ace-icon glyphicon glyphicon-trash\"></i> </button>";
								table.jqGrid('setRowData', ids[i], {
									act : del
								});
								scope.setRowValue({
									id : ids[i],
									index : i
								});
							}
						}
						var width = $('.page-content').width();
						scope.table.setGridWidth(width);
						scope.currentPage = $('.ui-pg-input');
						scope.pageSize = $('.ui-pg-selbox');
						scope.currentPage.val(scope.current + 1);
						scope.currentPage.attr('disabled', 'disabled');
						if (scope.data.total) {
							$('#sp_1_grid-pager').text(scope.data.total);
						}
						$compile($(scope.table))(scope);
						if (!scope.bindPaging) {
							scope.onPaging();
							scope.bindPaging = true;
						}
					},
					onSelectRow : function(id) {
						scope.onSelectRow({
							id : id
						});
					},
					onPaging : function(e) {
					},
					autowidth : true
				});
			}
		});
		scope.$watch('pageSize', function() {
			if (scope.pageSize) {
				scope.pageSize.unbind("change");
				scope.pageSize.bind('change', function() {
					scope.reload({
						page : 0,
						size : $(this).val()
					});
				});
			}
		});
		/*rewrite paging on jqtable*/
		scope.onPaging = function() {
			var next = $("#next_grid-pager");
			next.find("span").prepend("<i class='glyphicon glyphicon-chevron-right'></i>");
			var pre = $("#prev_grid-pager");
			pre.find("span").prepend("<i class='glyphicon glyphicon-chevron-left'></i>");
			var first = $("#first_grid-pager");
			first.find("span").prepend("<i class='glyphicon glyphicon-backward'></i>");
			var last = $("#last_grid-pager");
			last.find("span").prepend("<i class='glyphicon glyphicon-forward'></i>");
			next.click(function() {
				if (scope.current < (scope.data.total - 1)) {
					scope.current++;
					console.log(scope.current, scope.data.total - 1);
					scope.reloadPage();
				}
			});
			pre.click(function() {
				if (scope.current > 0) {
					scope.current--;
					console.log(scope.current);
					scope.reloadPage();
				}
			});
			last.click(function() {
				if (scope.data.total > 0) {
					scope.current = scope.data.total - 1;
					console.log(scope.current);
					scope.reloadPage();
				}
			});
			first.click(function() {
				scope.current = 0;
				console.log(scope.current);
				scope.reloadPage();
			});
		};
		scope.reloadPage = function() {
			if (localStorage.current != scope.current) {
				scope.reload({
					page : scope.current,
					size : scope.pageSize.val()
				});
				localStorage.current = scope.current;
				var cur = scope.current + 1;
				scope.currentPage.val(cur);
			}
		};
		scope.getListId = function() {
			return scope.table.jqGrid('getDataIDs');
		};
		scope.$parent.getTable = function() {
			return scope.table;
		};
		/*get all data of this table*/
		scope.$parent.getData = function() {
			return scope.table.jqGrid('getGridParam', 'data');
		};
		/* bind event: data in jq table's changed */
		scope.$watch('data.content', function(newdata) {
			scope.table.jqGrid('clearGridData');
			scope.table.jqGrid('setGridParam', {
				data : newdata
			});
			scope.table.trigger('reloadGrid');
		}, true);
		/*get value of row with specify key*/
		scope.$parent.getId = function(id, key) {
			return scope.table.jqGrid("getCell", id, key);
		};
		scope.deleteRow = function(rowId) {
			bootbox.confirm("Xóa sản phẩm đã chọn?", function(result) {
				if (result) {
					var id = scope.$parent.getId(rowId, 'productId');
					scope.data.content = _.filter(scope.data.content, function(obj) {
						return obj.productId !== id;
					});
					console.log(scope.data.content);
					scope.table.delRowData(rowId);
				}
			});
		};
	}

	return {
		restrict : 'E',
		template : "<table id='grid-table'></table><div id='grid-pager'></div>",
		scope : {
			tblConfig : '=',
			data : '=',
			onSelectRow : '&selectRow',
			reload : '&reload',
			loadComplete : '&loadComplete',
			setRowValue : '&setRowValue'
		},
		transclude : true,
		link : init
	};
}]);

