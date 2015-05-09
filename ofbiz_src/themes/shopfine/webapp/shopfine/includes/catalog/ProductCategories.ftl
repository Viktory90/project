					<div class="categories">
						<div class="titleHeader clearfix">
							<h3>Categories</h3>
						</div><!--end titleHeader-->
						<ul class="unstyled">
  <#if (completedTree?has_content)>
    <#list completedTree?sort_by("productCategoryId") as root>
				      		<li>
	  <#if (root.child?has_content)>
				      			<a class="invarseColor" href="<@ofbizCatalogAltUrl productCategoryId=root.productCategoryId/>"><#if root.categoryName?exists>${root.categoryName?js_string}<#elseif root.categoryDescription?exists>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if></a>
				      			<div>
					      			<ul class="submenu">
    		<#list root.child?sort_by("productCategoryId") as child>
					      				<li><a class="invarseColor" href="<@ofbizCatalogAltUrl productCategoryId=child.productCategoryId/>"><#if child.categoryName?exists>${child.categoryName?js_string}<#elseif child.categoryDescription?exists>${child.categoryDescription?js_string}<#else>${child.productCategoryId?js_string}</#if></a></li>
    		</#list>
					      			</ul>
					      		</div>
	  <#else>
				      			<a href="<@ofbizCatalogAltUrl productCategoryId=root.productCategoryId/>"><#if root.categoryName?exists>${root.categoryName?js_string}<#elseif root.categoryDescription?exists>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if></a>
	  </#if>
				      		</li>
    </#list>
  </#if>
						</ul>
					</div><!--end categories-->