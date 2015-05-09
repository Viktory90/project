					<div id="featuredItems">

							<!-- <div class="span12"> -->
							<div class="titleHeader clearfix">
								<h3>${uiLabelMap.ProductProductsLastViewed}</h3>
							</div><!--end titleHeader-->
							<!-- </div> -->

						<div class="row">

<#if sessionAttributes.lastViewedProducts?exists && sessionAttributes.lastViewedProducts?has_content>

	<ul class="hProductItems clearfix">
    <#list sessionAttributes.lastViewedProducts as productId>
          ${setRequestAttribute("optProductId", productId)}
          ${setRequestAttribute("listIndex", productId_index)}
          ${screens.render("component://shopfine/widget/CatalogScreens.xml#productsummary")}
    </#list>
  	</ul>

<#else>

    <hr />
    <div>${uiLabelMap.ProductNotViewedAnyProducts}</div>
</#if>
						</div><!--end row-->
					</div><!--end featuredItems-->