<#if productCategoryList?has_content>
				<div id="featuredItems">
						<!-- <div class="span12"> -->
						<div class="titleHeader clearfix">
							<h3>Popular Categories</h3>
						</div><!--end titleHeader-->
						<!-- </div> -->

						<div class="row">

							<ul class="hProductItems clearfix">
	    
	             <#list productCategoryList as childCategoryList>
                   <#assign cateCount = 0/>
                   <#list childCategoryList as productCategory>

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

								<li class="span2 clearfix">
									<div class="thumbnail">
										<a href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>"><img src="${categoryImageUrl}"></a>
									</div>
									<div class="thumbSetting">
										<div class="thumbTitle">
											<a href="<@ofbizCatalogAltUrl productCategoryId=productCategoryId/>" class="invarseColor">
												${productCategory.categoryName!productCategoryId}
											</a>
										</div>
									</div>
								</li>
			
                   </#list>
                        <#assign cateCount = cateCount + 1/>
                 </#list>
                 			</ul>
                 		</div>
				</div>
</#if>
