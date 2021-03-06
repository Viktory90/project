<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<script type="text/javascript">
    function callDocumentByPaginate(info) {
        var str = info.split('~');
        var checkUrl = '<@ofbizUrl>categoryAjaxFired</@ofbizUrl>';
        if(checkUrl.search("http"))
            var ajaxUrl = '<@ofbizUrl>categoryAjaxFired</@ofbizUrl>';
        else
            var ajaxUrl = '<@ofbizUrl>categoryAjaxFiredSecure</@ofbizUrl>';
            
        //jQuerry Ajax Request
        jQuery.ajax({
            url: ajaxUrl,
            type: 'POST',
            data: {"category_id" : str[0], "VIEW_SIZE" : str[1], "VIEW_INDEX" : str[2]},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#content').html(msg);
            }
        });
       
     }
</script>


<div class="box">
<#if productCategory?exists>
	<#assign categoryImageUrl = "/images/defaultImage.jpg">
    <#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
    <#assign categoryDescription = categoryContentWrapper.get("DESCRIPTION")?if_exists/>
    <#if productCategory.categoryImageUrl?has_content>
        <#assign categoryImageUrl = productCategory.categoryImageUrl/>
    <#elseif productCategoryMembers?has_content>
        <#assign productCategoryMember = Static["org.ofbiz.entity.util.EntityUtil"].getFirst(productCategoryMembers)/>
        <#assign product = delegator.findOne("Product", Static["org.ofbiz.base.util.UtilMisc"].toMap("productId", productCategoryMember.productId), false)/>
        <#if product.smallImageUrl?has_content>
            <#assign categoryImageUrl = product.smallImageUrl/>
        </#if>
    </#if>
    <#--
    <#if categoryName?has_content>
        <div class="box-heading">
    		<span>${categoryName}</span>
   		</div>
    </#if>
    -->
    <#--
    <div class="category-info">
    	<div class="image"><img src="${categoryImageUrl}" alt="Electronics"></div>
	    <#if categoryDescription?has_content>
	        <p>${categoryDescription}</p>
	    </#if>
	    <#if productCategoryList?has_content>
		    <div class="subcat">
			    <h2>REFINE SEARCH</h2>
		    	<div class="category-list">
			    	<ul class="list-item">	          	
					<#list productCategoryList as childCategoryList>
		               <#assign cateCount = 0/>
		                   <#assign productCategoryId = childCategoryList.productCategoryId/>
		                   <#assign categoryImageUrl = "/images/defaultImage.jpg">
		                   <#assign productCategoryMembers = delegator.findByAnd("ProductCategoryAndMember", Static["org.ofbiz.base.util.UtilMisc"].toMap("productCategoryId", productCategoryId), Static["org.ofbiz.base.util.UtilMisc"].toList("-quantity"), false)>
		                   <#if childCategoryList.categoryImageUrl?has_content>
		                        <#assign categoryImageUrl = childCategoryList.categoryImageUrl/>
		                   <#elseif productCategoryMembers?has_content>
		                        <#assign productCategoryMember = Static["org.ofbiz.entity.util.EntityUtil"].getFirst(productCategoryMembers)/>
		                        <#assign product = delegator.findOne("Product", Static["org.ofbiz.base.util.UtilMisc"].toMap("productId", productCategoryMember.productId), false)/>
		                        <#if product.smallImageUrl?has_content>
		                            <#assign categoryImageUrl = product.smallImageUrl/>
		                        </#if>
		                   </#if> 
							<li>
								<a href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>">${childCategoryList.categoryName!productCategoryId}</a>
							</li>
		                    <#assign cateCount = cateCount + 1/>
		             </#list>
		             </ul>
	             </div>
             </div>
 	    </#if>
    </div>
     -->
    <#if hasQuantities?exists>
      <form method="post" action="<@ofbizUrl>addCategoryDefaults<#if requestAttributes._CURRENT_VIEW_?exists>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="thecategoryform" style='margin: 0;'>
        <input type='hidden' name='add_category_id' value='${productCategory.productCategoryId}'/>
        <#if requestParameters.product_id?exists><input type='hidden' name='product_id' value='${requestParameters.product_id}'/></#if>
        <#if requestParameters.category_id?exists><input type='hidden' name='category_id' value='${requestParameters.category_id}'/></#if>
        <#if requestParameters.VIEW_INDEX?exists><input type='hidden' name='VIEW_INDEX' value='${requestParameters.VIEW_INDEX}'/></#if>
        <#if requestParameters.SEARCH_STRING?exists><input type='hidden' name='SEARCH_STRING' value='${requestParameters.SEARCH_STRING}'/></#if>
        <#if requestParameters.SEARCH_CATEGORY_ID?exists><input type='hidden' name='SEARCH_CATEGORY_ID' value='${requestParameters.SEARCH_CATEGORY_ID}'/></#if>
        <a href="javascript:document.thecategoryform.submit()" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.ProductAddProductsUsingDefaultQuantities}</span></a>
      </form>
    </#if>
 <#--   <#assign categoryImageUrl = categoryContentWrapper.get("CATEGORY_IMAGE_URL")?if_exists/> -->
 <#-- BEGIN	${screens.render("component://bigshop/widget/CatalogScreens.xml#categorydetailFilter")} -->
 <#macro paginationControls>
    <#assign viewIndexMax = Static["java.lang.Math"].ceil((listSize - 1)?double / viewSize?double)>
      <#if (viewIndexMax?int > 0)>
            <#-- End Page Select Drop-Down -->
            <#if (viewIndex?int > 0)>
                <#-- a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonPrevious}</a --> |
                <a href="javascript: void(0);" onclick="callDocumentByPaginate('${productCategoryId}~${viewSize}~${viewIndex?int - 1}');" class="buttontext">${uiLabelMap.CommonPrevious}</a> |
            </#if>
            <#if ((listSize?int - viewSize?int) > 0)>
                <span>${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
            </#if>
            <#if highIndex?int < listSize?int>
             <#-- | <a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int + 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonNext}</a -->
             | <a href="javascript: void(0);" onclick="callDocumentByPaginate('${productCategoryId}~${viewSize}~${viewIndex?int + 1}');" class="buttontext">${uiLabelMap.CommonNext}</a>
            </#if>
 </#if>
</#macro>   
		 <#-- comment
		 <div class="product-filter"><b>
		    <div class="display"><b>${uiLabelMap.BigshopDisplay}:</b> <a title="List" class="grid-icon" onclick="display('list');">List</a><span class="list1-icon">Grid</span></div>
				<#if showFilter?exists>
					<form name="formFilter" action="<@ofbizUrl>category/~category_id=${productCategoryId}</@ofbizUrl>" method="post" style="margin:0px">
						<input type=hidden name="sortAscending" value="${sortAscending?if_exists}"/>
					    <div class="limit">
							${uiLabelMap.CommonShow}:
							<select name="viewSize" onchange="javascript:form.submit();">
								<option value="8" <#if viewSize?int==8>selected="selected"</#if>>8</option>
								<option value="16" <#if viewSize?int==16>selected="selected"</#if>>16</option>
								<option value="20" <#if viewSize?int==20>selected="selected"</#if>>20</option>
								<option value="24" <#if viewSize?int==24>selected="selected"</#if>>24</option>
								<option value="32" <#if viewSize?int==32>selected="selected"</#if>>32</option>
								<option value="40" <#if viewSize?int==40>selected="selected"</#if>>40</option>
							</select>
						</div>
					    <div class="sort"><b>${uiLabelMap.CommonSortedBy}:</b>
					      <select name="sortOrder" onchange="javascript:document.formFilter.submit();">
					        <option value="" <#if sortOrder?has_content && sortOrder.equals("SortKeywordRelevancy")>selected="selected"</#if>>${uiLabelMap.EcommerceDefault}</option>
					        <option value="SortProductField:productName" <#if sortOrder?has_content && sortOrder.equals("SortProductField:productName")>selected="selected"</#if>>${uiLabelMap.ProductProductName}</option>
					        <option value="SortProductField:totalQuantityOrdered" <#if sortOrder?has_content && sortOrder.equals("SortProductField:totalQuantityOrdered")>selected="selected"</#if>>${uiLabelMap.ProductPopularityByOrders}</option>
					        <option value="SortProductField:totalTimesViewed" <#if sortOrder?has_content && sortOrder.equals("SortProductField:totalTimesViewed")>selected="selected"</#if>>${uiLabelMap.ProductPopularityByViews}</option>
					        <option value="SortProductField:averageCustomerRating" <#if sortOrder?has_content && sortOrder.equals("SortProductField:averageCustomerRating")>selected="selected"</#if>>${uiLabelMap.ProductCustomerRating}</option>
					        <option value="SortProductPrice:DEFAULT_PRICE" <#if sortOrder?has_content && sortOrder.equals("SortProductPrice:DEFAULT_PRICE")>selected="selected"</#if>>${uiLabelMap.ProductDefaultPrice}</option>
					      </select>
					    </div>
					</form>
				</#if>
		 </div>
		  -->
  <#-- END	${screens.render("component://bigshop/widget/CatalogScreens.xml#categorydetailFilter")} -->
</#if>
<#--
<#if productCategoryLinkScreen?has_content && productCategoryLinks?has_content>
    <div class="productcategorylink-container">
        <#list productCategoryLinks as productCategoryLink>
            ${setRequestAttribute("productCategoryLink",productCategoryLink)}
            ${screens.render(productCategoryLinkScreen)}
        </#list>
    </div>
</#if>
-->
<#if productCategoryMembers?has_content>
    <#-- Pagination -->
    <#if paginateEcommerceStyle?exists>
        <@paginationControls/>
    <#else>
        <#include "component://common/webcommon/includes/htmlTemplate.ftl"/>
        <#assign commonUrl = "category?category_id="+ parameters.category_id?if_exists + "&"/>
        <#--assign viewIndex = viewIndex - 1/-->
        <#assign viewIndexFirst = 0/>
        <#assign viewIndexPrevious = viewIndex - 1/>
        <#assign viewIndexNext = viewIndex + 1/>
        <#assign viewIndexLast = Static["java.lang.Math"].floor(listSize/viewSize)/>
        <#assign messageMap = Static["org.ofbiz.base.util.UtilMisc"].toMap("lowCount", lowIndex, "highCount", highIndex, "total", listSize)/>
        <#assign commonDisplaying = Static["org.ofbiz.base.util.UtilProperties"].getMessage("CommonUiLabels", "CommonDisplaying", messageMap, locale)/>
        <@nextPrev commonUrl=commonUrl ajaxEnabled=false javaScriptEnabled=false paginateStyle="nav-pager" paginateFirstStyle="nav-first" viewIndex=viewIndex highIndex=highIndex listSize=listSize viewSize=viewSize ajaxFirstUrl="" firstUrl="" paginateFirstLabel="" paginatePreviousStyle="nav-previous" ajaxPreviousUrl="" previousUrl="" paginatePreviousLabel="" pageLabel="" ajaxSelectUrl="" selectUrl="" ajaxSelectSizeUrl="" selectSizeUrl="" commonDisplaying=commonDisplaying paginateNextStyle="nav-next" ajaxNextUrl="" nextUrl="" paginateNextLabel="" paginateLastStyle="nav-last" ajaxLastUrl="" lastUrl="" paginateLastLabel="" paginateViewSizeLabel="" />
    </#if>
      <div class="product-grid">
      
      
	<!-- START PRIMARY -->
	<div id="primary" class="sidebar-no">
	    <div class="container group" style="margin-left:25px">
		    <div class="row">
		        <!-- START CONTENT -->
		        <div id="content-home" class="span12 content group">
	                <div id="post-2" class="post-2 page type-page status-publish hentry group instock">
	            		<div class="woocommerce">
							<div class="yit-wcan-container">
							<ul class="products">
							<#assign productNo = 0>
	        <#list productCategoryMembers as productCategoryMember>
	            ${setRequestAttribute("optProductId", productCategoryMember.productId)}
	            ${setRequestAttribute("productCategoryMember", productCategoryMember)}
	            ${setRequestAttribute("listIndex", productCategoryMember_index)}
	            ${setRequestAttribute("productNo", productNo)}
	            <li class="product group grid with-hover with-border <#if productNo%4 == 0>first</#if> span3 css3 open-on-mobile">
	            ${screens.render(productsummaryScreen)}
	            </li>
	            <#assign productNo = productNo + 1>
	        </#list>
	        				</ul></div>
							<div class="es-nav">
								<span class="es-nav-prev">Previous</span>
								<span class="es-nav-next">Next</span>
							</div>
						</div> <!-- end woocommerce -->
						
						
						
						<#include "primaryPart2.ftl">
						
				</div>
			</div>
		</div>
		<!-- END CONTENT -->
		
		
		
		
		
		
		
		
		
		
		
		<script type="text/javascript" charset="utf-8">
		jQuery(function($){
			var carouFredSel;
			var carouFredSelOptions = {
				responsive: false,
				auto: true,
				items: 4,
				circular: true,
				infinite: true,
				debug: false,
		        prev: '.section-portfolio-slider .prev',
		        next: '.section-portfolio-slider .next',
		        swipe: {
		          	onTouch: true
		        },
		        scroll : {
		            items     : 1,
		            pauseOnHover: true
		        } 
			};
		
		
		/*
			$('.products_tabs').imagesLoaded(function(){
				$('.products:first', $(this)).each(function(){
		
			   		var prev = $(this).find('.es-nav-prev');
			   		var next = $(this).find('.es-nav-next');
			
			   		carouFredSelOptions.prev = prev;
			   		carouFredSelOptions.next = next;
		
					carouFredSel = $(this).carouFredSel(carouFredSelOptions);
				});
				
		    });
		*/
		
			$('.panel', $('.products_tabs')).on('yit_tabopened', function(){
				
				var t = $(this);
		   		var prev = $(this).find('.es-nav-prev');
		   		var next = $(this).find('.es-nav-next');
		
		   		carouFredSelOptions.prev = prev;
		   		carouFredSelOptions.next = next;
				
				if( $('body').outerWidth() <= 767 ) {
					t.find('li').each(function(){
						$(this).width( t.width() );
					});
								
					carouFredSelOptions.items = 1;
				} else {
					t.find('li').each(function(){
						$(this).attr('style', '');
					});
								
					carouFredSelOptions.items = 4;
				}
				
				carouFredSel = $(this).find('.products').carouFredSel(carouFredSelOptions);
			});
			
		    $('.panel', $('.products_tabs')).on('yit_tabclosed', function(){
		    	//carouFredSel.trigger('destroy', false).attr('style','');
		    });
		    
		    // create slider when page is loaded
		    $('.panel', $('.products_tabs')).imagesLoaded(function(){
		        $(window).trigger('resize');    
		    });
		
		    $(window).resize(function(){
		    	var t = carouFredSel.parents('.panel');
		    	carouFredSel.trigger('destroy', false).attr('style','');
		    	
				if( $('body').outerWidth() <= 767 ) {
					t.find('li').each(function(){
						$(this).width( t.width() );
					});
									
					carouFredSelOptions.items = 1;
				} else {
					t.find('li').each(function(){
						$(this).attr('style', '');
					});
								
					carouFredSelOptions.items = 4;
				}
		    	
		    	carouFredSel.carouFredSel(carouFredSelOptions);
		    	$('.es-nav-prev, .es-nav-next').removeClass('hidden').show();
		    });
		    
		    $(document).on('feature_tab_opened', function(){
		        $(window).trigger('resize');
		        $('.es-nav-prev, .es-nav-next').removeClass('hidden').show();
		    });
		                                                      
		
		/*
			$('.products_tabs').each(function(){
				$('.border-box > div.panel', $(this)).on('yit_tabopened', function(){
					$(this).find('.products-slider-wrapper').elastislide( elastislide_defaults );
				});
				$('.border-box > div.panel', $(this)).on('yit_tabclosed', function(){
					$(this).find('.products-slider-wrapper').elastislide( 'destroy' );
				});
			});
		*/
		});
		</script>
		
		
		</div>
		        
		<!-- START COMMENTS -->
		<div id="comments"></div>
		<!-- END COMMENTS -->
	</div>
	<!-- end container group -->
	
		        	        
	<!-- START EXTRA CONTENT -->
	<!-- END EXTRA CONTENT -->
	<div class="clear"></div>
	<div class="clear"></div>
	
	
	
    </div>
    <!-- END PRIMARY -->
</div>
</div>


</div>
    <#if paginateEcommerceStyle?exists> 
        <@paginationControls/>
    </#if>
<#else>
    <hr />
    <div>${uiLabelMap.ProductNoProductsInThisCategory}</div>
</#if>
</div>

<script type="text/javascript">
function display(view) {
	if (view == 'list') {
		$('.product-grid').attr('class', 'product-list');
		
		$('.product-list > div').each(function(index, element) {
			html  = '<div class="right">';
			html += '  <div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '  <div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '  <div class="compare">' + $(element).find('.compare').html() + '</div>';
			html += '</div>';			
			
			html += '<div class="left">';
			
			var image = $(element).find('.image').html();
			
			if (image != null) { 
				html += '<div class="image">' + image + '</div>';
			}
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
					
			html += '  <div class="name">' + $(element).find('.name').html() + '</div>';
			html += '  <div class="description">' + $(element).find('.description').html() + '</div>';
			
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
				
			html += '</div>';

						
			$(element).html(html);
		});		
		
		$('.display').html('<b>${uiLabelMap.BigshopDisplay}:</b> <span class="grid1-icon">List</span> <a title="Grid" class="list-icon" onclick="display(\'grid\');">Grid</a>');
		
		$.cookie('display', 'list'); 
	} else {
		$('.product-list').attr('class', 'product-grid');
		
		$('.product-grid > div').each(function(index, element) {
			html = '';
			
			var image = $(element).find('.image').html();
			
			if (image != null) {
				html += '<div class="image">' + image + '</div>';
			}
			
			html += '<div class="name">' + $(element).find('.name').html() + '</div>';
			html += '<div class="description">' + $(element).find('.description').html() + '</div>';
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
			
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
						
			html += '<div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '<div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '<div class="compare">' + $(element).find('.compare').html() + '</div>';
			
			$(element).html(html);
		});	
					
		$('.display').html('<b>${uiLabelMap.BigshopDisplay}:</b> <a title="List" class="grid-icon" onclick="display(\'list\');">List</a><span class="list1-icon">Grid</span>');
		
		$.cookie('display', 'grid');
	}
}

view = $.cookie('display');

if (view) {
	display(view);
} else {
	display('grid');
}
</script>