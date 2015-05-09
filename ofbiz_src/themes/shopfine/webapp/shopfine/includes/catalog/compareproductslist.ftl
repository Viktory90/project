					<div id="homeSpecial">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.ProductCompareProducts}</h3>
							<div class="pagers">
								<div class="btn-toolbar">
									<div class="btn-group">
										<button class="btn btn-mini vNext"><i class="icon-caret-down"></i></button>
										<button class="btn btn-mini vPrev"><i class="icon-caret-up"></i></button>
									</div>
								</div>
							</div>
						</div><!--end titleHeader-->

<#assign productCompareList = Static["org.ofbiz.product.product.ProductEvents"].getProductCompareList(request)/>
<#if productCompareList?has_content>

						<ul class="vProductItems cycle-slideshow vertical clearfix"
					    data-cycle-fx="carousel"
					    data-cycle-timeout=0
					    data-cycle-slides="> li"
					    data-cycle-next=".vPrev"
					    data-cycle-prev=".vNext"
					    data-cycle-carousel-visible="2"
					    data-cycle-carousel-vertical="true"
					    >

    <#list productCompareList as product>
	    ${setRequestAttribute("optProductId", product.productId)}
	    ${screens.render(productsummaryScreen)}
    </#list>
    					</ul>
<#else/>
    ${uiLabelMap.ProductNoProductsToCompare}
</#if>
					    <a href="<@ofbizUrl>clearCompareList</@ofbizUrl>"><button class="btn btn-mini">${uiLabelMap.CommonClearAll}</button></a>
					    <a href="javascript:popUp('<@ofbizUrl secure="${request.isSecure()?string}">compareProducts</@ofbizUrl>', 'compareProducts', '1024', '1024')" ><button class="btn btn-mini">${uiLabelMap.ProductCompareProducts}</button></a>
					</div><!--end homeSpecial-->

