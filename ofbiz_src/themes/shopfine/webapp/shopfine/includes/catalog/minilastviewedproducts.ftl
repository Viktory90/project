<#assign maxToShow = 4/>
<#assign lastViewedProducts = sessionAttributes.lastViewedProducts?if_exists/>
<#if lastViewedProducts?has_content>
  <#if (lastViewedProducts?size > maxToShow)><#assign limit=maxToShow/><#else><#assign limit=(lastViewedProducts?size-1)/></#if>
					<div id="homeSpecial">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.EcommerceLastProducts}</h3>
							<div class="pagers">
								<div class="btn-toolbar">
									<div class="btn-group">
										<button class="btn btn-mini vNextLastViewed"><i class="icon-caret-down"></i></button>
										<button class="btn btn-mini vPrevLastViewed"><i class="icon-caret-up"></i></button>
									</div>
								</div>
							</div>
						</div><!--end titleHeader-->


						<ul class="vProductItems cycle-slideshow vertical clearfix"
					    data-cycle-fx="carousel"
					    data-cycle-timeout=0
					    data-cycle-slides="> li"
					    data-cycle-next=".vPrevLastViewed"
					    data-cycle-prev=".vNextLastViewed"
					    data-cycle-carousel-visible="${maxToShow}"
					    data-cycle-carousel-vertical="true"
					    >
					    
    <#list lastViewedProducts[0..limit] as productId>
	    ${setRequestAttribute("optProductId", productId)}
	    ${screens.render(productsummaryScreen)}
	</#list>
							</ul>
        							<#if (lastViewedProducts?size > maxToShow)>
										<a href="<@ofbizUrl>lastviewedproducts</@ofbizUrl>"><button class="btn btn-mini">${uiLabelMap.CommonMore}</button></a>
        							</#if>
        								<a href="<@ofbizUrl>clearLastViewed</@ofbizUrl>"><button class="btn btn-mini">${uiLabelMap.CommonClear}</button></a>
							
					</div><!--end homeSpecial-->
 <#else>
    <hr />
    <span class="pull-left">${uiLabelMap.ProductNoProductsInThisCategory}</span>
</#if>
					