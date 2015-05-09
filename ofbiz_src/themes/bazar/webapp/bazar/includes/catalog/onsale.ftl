<#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
<div id="onsale-2" class="widget-3 widget-last widget woocommerce widget_onsale">
	<h3>SPECIAL OFFERS</h3>
	<#if productCategoryMembers?has_content>
	<ul class="product_list_widget">
		<#list productCategoryMembers as productCategoryMember>
			${setRequestAttribute("optProductId", productCategoryMember.productId)}
		    ${setRequestAttribute("productCategoryMember", productCategoryMember)}
		    ${setRequestAttribute("listIndex", productCategoryMember_index)}
		    <li>
				${screens.render("component://bazar/widget/CatalogScreens.xml#productmini")}
			</li>
		</#list>

	</ul>
	<#else>
	<span class="pull-left">${uiLabelMap.ProductNoProductsInThisCategory}</span>
	</#if>
</div>