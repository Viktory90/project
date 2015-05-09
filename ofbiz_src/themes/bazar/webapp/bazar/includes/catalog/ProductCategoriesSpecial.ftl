<#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
<div id="special-offers" class="panel group" style="display: none;">
	<div class="products-slider-wrapper">
		<div class="products-slider" data-items="4">
			<h4>&nbsp;</h4>
			<div class="yit-wcan-container">
				<#if productCategoryMembers?has_content>
				<ul class="products">
					

					<#list productCategoryMembers as productCategoryMember>
						${setRequestAttribute("optProductId", productCategoryMember.productId)}
					    ${setRequestAttribute("productCategoryMember", productCategoryMember)}
					    ${setRequestAttribute("listIndex", productCategoryMember_index)}
					    <li class="product group grid with-hover with-border span3 css3 open-on-mobile">
							${screens.render(productLeftShowScreen)}
						</li>
					</#list>

				</ul>
				<#else>
				<span class="pull-left">${uiLabelMap.ProductNoProductsInThisCategory}</span>
				</#if>
			</div>
			<div class="es-nav">
				<span class="es-nav-prev">Previous</span><span class="es-nav-next">Next</span>
			</div>
		</div>
	</div>
	<div class="es-carousel-clear"></div>
</div>