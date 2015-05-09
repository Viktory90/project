<#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
<div id="top-rated-products-2" class="widget-2 widget woocommerce widget_top_rated_products">
	<h3>BEST SHELLING</h3>
	<#if productCategoryList?has_content>
		<#list productCategoryList as childCategoryList>
                   <#assign cateCount = 0/>
                   <#list childCategoryList as productCategory>
                       <#if (cateCount > 2)>
                            <#assign cateCount = 0/>
                       </#if>
                       <#assign productCategoryId = productCategory.productCategoryId/>
                       <#assign categoryImageUrl = "/images/defaultImage.jpg">
                       <#assign productCategoryMembers = delegator.findByAnd("ProductCategoryAndMember", Static["org.ofbiz.base.util.UtilMisc"].toMap("productCategoryId", productCategoryId), Static["org.ofbiz.base.util.UtilMisc"].toList("-quantity"), false)>
                       <#if productCategory.categoryImageUrl?has_content>
                            <#assign categoryImageUrl = productCategory.categoryImageUrl/>
                       <#elseif productCategoryMembers?has_content>
                            <#assign productCategoryMember = Static["org.ofbiz.entity.util.EntityUtil"].getFirst(productCategoryMembers)/>
                            <#assign product = delegator.findOne("Product", Static["org.ofbiz.base.util.UtilMisc"].toMap("productId", productCategoryMember.productId), false)/>
                            <#if product.smallImageUrl?has_content>
                                <#assign categoryImageUrl = product.smallImageUrl/>
                            </#if>
                       </#if>
                            <div>
                                <div class="image">
                                    <a href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>">
                                        <img alt="Small Image" src="${categoryImageUrl}">
                                    </a>
                                </div>
                                <div class="name">
                                    <a href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>">${productCategory.categoryName!productCategoryId}</a>
                                </div>
                                <div class="rating">
                                	
                                </div>
                                <div class="rating">
                                	
                                </div>
                                <div class="cart">
                                	<input type="button" value="Add to Cart" onclick="addToCart('40');" class="button">
                                </div>
                                <div class="productinfo">
                                    <ul>
                                    <#if productCategoryMembers?exists>
                                        <#assign i = 0/>
                                        <#list productCategoryMembers as productCategoryMember>
                                            <#if (i > 2)>
                                                <#if productCategoryMembers[i]?has_content>
                                                    <a class="linktext" href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>">
                                                        <span>More...</span>
                                                    </a>
                                                </#if>
                                                <#break>
                                            </#if>
                                            <#if productCategoryMember?has_content>
                                                <#assign product = delegator.findOne("Product", Static["org.ofbiz.base.util.UtilMisc"].toMap("productId", productCategoryMember.productId), false)>
                                                <li class="browsecategorytext">
                                                    <a class="linktext" href="<@ofbizCatalogAltUrl productCategoryId="PROMOTIONS" productId="${product.productId}"/>">
                                                        ${product.productName!product.productId}
                                                    </a>
                                                </li>
                                            </#if>
                                            <#assign i = i+1/>
                                        </#list>
                                    </#if>
                                    </ul>
                                </div>
                            </div>
                        <#assign cateCount = cateCount + 1/>
                 </#list>
            </#list>
	<#else>
		<span class="pull-left">${uiLabelMap.ProductNoProductsInThisCategory}</span>
	</#if>
</div>