/*global todomvc, angular */
'use strict';
/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
olbius.directive('category', ['$compile', 'CategoryService',
    function($compile, CategoryService) {
        function init(scope, element, attrs) {
            scope.categories = [];
            CategoryService.getAll().then(function(res) {
                var data = scope.initData(res.completedTreeCat);
                scope.categories = data;
                if (data && data.length !== 0) {
                    scope.categoryId = data[0].catId;
                }
            });
            scope.initData = function(categories) {
                var data = Array();
                data.push({
                	catName: "Tất cả",
                	catId : "all"
                });
                var catName = "";
                for (var x in categories) {
                    if (categories[x].categoryName !== null && categories[x].categoryName !== 'undefined'
                            && !($.isEmptyObject(categories[x].categoryName))) {
                        catName = categories[x].categoryName;
                    } else {
                        catName = categories[x].productCategoryId;
                    }
                    data.push({
                        catName: catName,
                        catId: categories[x].productCategoryId
                    });
                }
                return data;
            };
            scope.changeCategory = scope.$parent.changeCategory;
            scope.$parent.getCategoryId = function() {
                return scope.category;
            };
        }

        return {
            restrict: 'ACE',
            template: "<select id='categories' ng-model='categoryId'"
                    + "ng-options='ct.catId as ct.catName for ct in categories' "
                    + "class='col-lg-12 col-md-12 col-sm-12 col-xs-12'>"
                    + "</select>",
            scope: {
                categoryId: "="
            },
            link: init
        };
    }]);
