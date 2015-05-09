<#if showPromoImg>

					<div id="productSlider" class="carousel slide">
						<!-- Carousel items -->
					    <div class="carousel-inner">
				      	  <#assign isFirst=true>
					      <#list productPromos as productPromo>
					       		<#assign productPromoContentWrapper = Static["org.ofbiz.product.product.ProductPromoContentWrapper"].makeProductPromoContentWrapper(productPromo, request)/>
            					<#assign imageUrl = Static["org.ofbiz.product.product.ProductPromoContentWrapper"].getProductPromoContentAsText(productPromo, "ORIGINAL_IMAGE_URL", request)?if_exists>
				                <#if !imageUrl?string?has_content>
				                  <#assign imageUrl = productPromoContentWrapper.get("ORIGINAL_IMAGE_URL")?if_exists>
				                </#if>
				                <#if !imageUrl?string?has_content>
				                  <#assign imageUrl = "/images/defaultImage.jpg">
				                </#if>            					      

            					      
						      	<#if imageUrl?has_content>
				                    <#if isFirst>
							      		<div class="item active">
				                    <#else>
							      		<div class="item">
				                    </#if>
							      
							      	<#assign isFirst=false>
						            <a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>"><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${imageUrl}</@ofbizContentUrl>" alt=""></a>
						        		</div>
						      	</#if>
					      </#list>
						</div>
					    <!-- Carousel nav -->
					    <a class="carousel-control left" href="#productSlider" data-slide="prev">&lsaquo;</a>
					    <a class="carousel-control right" href="#productSlider" data-slide="next">&rsaquo;</a>
					</div><!--end productSlider-->
</#if>
