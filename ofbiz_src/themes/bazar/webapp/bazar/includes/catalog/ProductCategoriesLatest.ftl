<#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
<div class="border-box group">
		<div id="must-have" class="panel group showing"
			style="display: block;">
			<div class="products-slider-wrapper">
				<div class="products-slider" data-items="4">
					<h4>&nbsp;</h4>
					<div class="caroufredsel_wrapper"
						style="display: block; text-align: start; float: none; position: relative; top: auto; right: auto; bottom: auto; left: auto; z-index: auto; width: 1200px; height: 307.89599990844727px; margin: 0px 0px 14px -30px; overflow: hidden;">
						<#if productCategoryMembers?has_content>
							<ul class="products" style="text-align: left; float: none; position: absolute; top: 0px; right: auto; bottom: auto; left: 0px; margin: 0px; width: 4200px; height: 307.89599990844727px; z-index: auto;">
	
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
						<span class="es-nav-prev" style="display: block;">Previous</span>
						<span class="es-nav-next" style="display: block;">Next</span>
					</div>
				</div>
			</div>
			<div class="es-carousel-clear"></div>
		</div>
