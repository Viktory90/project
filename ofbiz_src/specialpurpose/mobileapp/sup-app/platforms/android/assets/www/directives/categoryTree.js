/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('categoryTree', ['CategoryService', 'ProductService',
    function(CategoryService, ProductService) {
        function init(scope, element, attrs) {
            scope.products = Array();
            scope.selected = Array();
            scope.categoryDom = $('#categories');
            element.ready(function() {
                CategoryService.getAll().then(function(data) {
                    scope.categories = data;
                    scope.drawTreeCategory(data.completedTreeCat);
                });
            });

            scope.drawTreeCategory = function(data) {
                var dataTree = new DataSourceTree({
                    data: scope.fillTree(data)
                });
                scope.categoryDom.ace_tree({
                    dataSource: dataTree,
                    loadingHTML: '<div class="tree-loading"><i class="ace-icon fa fa-refresh fa-spin blue"></i></div>',
                    'open-icon': 'ace-icon tree-minus',
                    'close-icon': 'ace-icon tree-plus',
                    'selectable': true,
                    'selected-icon': 'ace-icon fa fa-check',
                    'unselected-icon': 'ace-icon fa fa-check-square'
                });
                /*update tree*/
                scope.categoryDom.on('updated', function(e, ui) {
                    if (ui.eventType === "unselected") {
                        var del = localStorage.getItem(ui.item.find('a').attr('data-id'));
                        if (del) {
                            scope.selected = JSON.parse(del);
                        }
                        var arr1 = _.pluck(scope.products, "productId");
                        var arr2 = _.pluck(scope.selected, "productId");
                        var diff = _.difference(arr1, arr2);
                        scope.products = _.filter(scope.products, function(obj) {
                            return diff.indexOf(obj.productId) >= 0;
                        });
                        scope.$digest();
                    }
                });
                scope.categoryDom.on('selected', function(e, ui) {
                    for (var x in ui.info) {
                        scope.getProductOfCat(ui.info[x].id);
                    }
                });

            };
            scope.getProductOfCat = function(id) {
                ProductService.getByCategory(id, 0, 100).then(function(res) {
                    if (res.listProduct.length) {
                        localStorage.setItem(id, JSON.stringify(res.listProduct));
                        scope.products = _.uniq(_.union(scope.products, res.listProduct), false, function(item) {
                            return item.productId;
                        });
                    }
                });
            };
            scope.fillTree = function(data) {
                var retTree = new Object();
                var catName = "";
                $.each(data, function(key, val) {
                    if (val.categoryName !== null && val.categoryName !== 'undefined' && !($.isEmptyObject(val.categoryName))) {
                        catName = val.categoryName;
                    } else {
                        catName = val.productCategoryId;
                    }
                    var catId = val.productCategoryId;
                    var text = "<a href='javascript:void(0)' data-id='" + catId + "'>" + catName + "</a>";
                    if (!$.isEmptyObject(val.child)) {
                        var children = fillTree2(val["child"]);
                        retTree[catName] = {
                            name: text,
                            type: 'folder'
                        };
                        retTree[catName]["additionalParameters"] = {
                            'children': children
                        };
                    } else {
                        retTree[catName] = {
                            name: text,
                            id: catId,
                            type: 'item'
                        };
                    }
                });
                for (var i in data) {

                }
                return retTree;
            };
        }

        return {
            template: '<div id="categories" class="tree"></div>',
            restrict: 'ACE',
            link: init
        };
    }]);
//function getProductOfCat(id) {
//    var injector = angular.element(document.documentElement).injector();
//    var srv = injector.get('ProductService');
//    var scope = angular.element($("#categories")).scope();
//    
//}
