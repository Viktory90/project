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
            data: {"category_id" : str[0], "VIEW_SIZE" : str[1], "VIEW_INDEX" : str[2], "sortOrder" : str[3]},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#content').html(msg);
            }
        });
     }
</script>

<#assign productNo = 0>
<div id="primary" class="sidebar-left">
    <div class="container group">
        <div class="row">
        
            <!-- START CONTENT -->
            <div id="content-shop" class="span9 content group">            <!-- START PAGE META -->
                <div id="page-meta" class="group">
                	<h1 class="product-title page-title">Search Results:</h1>
                    <#list searchConstraintStrings as searchConstraintString>
                   ${searchConstraintString}
                    <!-- <h1 class="product-title page-title">Search Results: “glass”</h1>-->
                    </#list>
				
                    <p class="list-or-grid">
                        View as: 
                        <a title="List" class="grid-icon" onclick="display('list');">List</a>
                        <a title="List" class="grid-icon" onclick="display('grid');">Grid</a>
                    </p>
                    <nav class="woocommerce-breadcrumb" itemprop="breadcrumb">
                    	<#include "breadcrumbs.ftl">
                    </nav>
                    
                    <#if showFilter?exists>   
					<form class="woocommerce-ordering" name="formFilter" action="<@ofbizUrl>category/~category_id=${productCategoryId}</@ofbizUrl>" method="post" >
						<input type=hidden name="sortAscending" value="${sortAscending?if_exists}"/>
					    
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
					<#else>
					Khong co showFilter
				</#if>
				
                </div>
                <div class="yit-wcan-container">
                	<#if productIds?has_content>
               			<ul class="products">
	                        <#list productIds as productId> <#-- note that there is no boundary range because that is being done before the list is put in the content -->
	                        ${setRequestAttribute("optProductId", productId)}
	                        ${setRequestAttribute("listIndex", productId_index)}
	                     
	                        <li class="product-552 product group grid with-hover with-border span3 <#if productNo%4 == 0>first</#if> css3 open-on-mobile">
	                        	${screens.render(productsummaryScreen)}
	                        </li>
	                        <#assign productNo = productNo + 1>
	                        </#list>
                    	</ul>
                    <#else>
                    	<h3>&nbsp;${uiLabelMap.ProductNoResultsFound}.</h3>
                    </#if>
				</div>
                <div class="clear"></div>

                <nav id="pagination-wrapper"></nav>             

                <script type="text/javascript">
                    /* <![CDATA[ */
                    var yit_shop_view_cookie = 'yit_bazar_28_shop_view';
                    /* ]]> */
                </script>

            </div>                     

            <!-- START SIDEBAR -->
            <div id="sidebar-shop-sidebar" class="span3 sidebar group">
                <div id="price_filter-3" class="widget-1 widget-first widget woocommerce widget_price_filter"><h3><div class="minus"></div>FILTER BY PRICE</h3><form method="get" action="http://demo.yithemes.com/bazar">
                        <div class="price_slider_wrapper">
                            <div class="price_slider ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all" style=""><div class="ui-slider-range ui-widget-header" style="left: 0%; width: 100%;"></div><a class="ui-slider-handle ui-state-default ui-corner-all" href="http://demo.yithemes.com/bazar/?s=glass&post_type=product#" style="left: 0%;"></a><a class="ui-slider-handle ui-state-default ui-corner-all" href="http://demo.yithemes.com/bazar/?s=glass&post_type=product#" style="left: 100%;"></a></div>
                            <div class="price_slider_amount">
                                <input type="text" id="min_price" name="min_price" value="" data-min="0" placeholder="Min price" style="display: none;">
                                <input type="text" id="max_price" name="max_price" value="" data-max="39" placeholder="Max price" style="display: none;">
                                <button type="submit" class="button">Filter</button>
                                <div class="price_label" style="">
                                    Price: <span class="from">$0</span> — <span class="to">$39</span>
                                </div>
                                <input type="hidden" name="s" value="glass"><input type="hidden" name="post_type" value="product">
                                <div class="clear"></div>
                            </div>
                        </div>
                    </form></div><div id="yith-woo-ajax-navigation-4" class="widget-2 widget yith-woo-ajax-navigation woocommerce widget_layered_nav"><h3><div class="minus"></div>FILTER BY CATEGORY</h3><ul class="yith-wcan-list yith-wcan"><li><a href="http://demo.yithemes.com/bazar/shop/?filter_product-type=30&s=glass&post_type=product">Glasses</a> <small class="count">2</small></li></ul></div><div id="yith-woo-ajax-navigation-2" class="widget-3 widget yith-woo-ajax-navigation woocommerce widget_layered_nav" style="display:none"></div><div id="yith-woo-ajax-navigation-3" class="widget-4 widget-last widget yith-woo-ajax-navigation woocommerce widget_layered_nav" style="display:none"></div>    </div>
            <!-- END SIDEBAR -->

            <div class="product-extra span9">

            </div>

        </div>    
    </div>
</div>   
        

<script type="text/javascript">
    jQuery(document).ready(function($){
        woo_update_total_compare_list = function(){ 
            var data = {
                action: 		"woocp_update_total_compare",
                security: 		"e9a7cb4f70"
            };
            $.post( ajax_url, data, function(response) {
                total_compare = $.parseJSON( response );
                $("#total_compare_product").html("("+total_compare+")");
                $(".woo_compare_button_go").trigger("click");
            });
        };

    });
</script>                         
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
		
		$('.display').html('<b>Display:</b> <span class="grid1-icon">List</span> <a title="Grid" class="list-icon" onclick="display(\'grid\');">Grid</a>');
		
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
					
		$('.display').html('<b>Display:</b> <a title="List" class="grid-icon" onclick="display(\'list\');">List</a><span class="list1-icon">Grid</span>');
		
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