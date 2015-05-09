<#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>

<div id="recently_viewed_products-2" class="widget-1 widget-first widget woocommerce widget_recently_viewed_products">
	<h3>WHAT's NEW</h3>
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

