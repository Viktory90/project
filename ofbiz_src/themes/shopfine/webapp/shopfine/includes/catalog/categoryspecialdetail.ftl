					<div id="homeSpecial">
						<div class="titleHeader clearfix">
							<h3>Special</h3>
							<div class="pagers">
								<div class="btn-toolbar">
									<div class="btn-group">
										<button class="btn btn-mini vNextSpecial"><i class="icon-caret-down"></i></button>
										<button class="btn btn-mini vPrevSpecial"><i class="icon-caret-up"></i></button>
									</div>
								</div>
							</div>
						</div><!--end titleHeader-->
						<#if productCategoryMembers?has_content>
												<ul class="vProductItems cycle-slideshow vertical clearfix"
											    data-cycle-fx="carousel"
											    data-cycle-timeout=2000
											    data-cycle-slides="> li"
											    data-cycle-next=".vPrevSpecial"
											    data-cycle-prev=".vNextSpecial"
											    data-cycle-carousel-visible="2"
											    data-cycle-carousel-vertical="true"
											    >
											    
							<#list productCategoryMembers as productCategoryMember>
							    ${setRequestAttribute("optProductId", productCategoryMember.productId)}
							    ${setRequestAttribute("productCategoryMember", productCategoryMember)}
							    ${setRequestAttribute("listIndex", productCategoryMember_index)}
							    ${screens.render(productsummaryScreen)}
											    
							</#list>
								</ul>
							<#else>
							    <hr />
							    <span class="pull-left">${uiLabelMap.ProductNoProductsInThisCategory}</span>
							</#if>
					</div><!--end homeSpecial-->