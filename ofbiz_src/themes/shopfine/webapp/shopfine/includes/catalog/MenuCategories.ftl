				      	<ul class="nav">
				      		<li ><a href="<@ofbizUrl>main</@ofbizUrl>"><i class="icon-home"></i></a></li>
  <#if (completedTree?has_content)>
    <#list completedTree?sort_by("productCategoryId") as root>
				      		<li <#if productCategoryId?exists && (root.productCategoryId==productCategoryId)>class="active"</#if> >
	  <#if (root.child?has_content)>
				      			<a href="<@ofbizCatalogAltUrl productCategoryId=root.productCategoryId/>"><#if root.categoryName?exists>${root.categoryName?js_string}<#elseif root.categoryDescription?exists>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if> &nbsp;<i class="icon-caret-down"></i></a>
				      			<div>
					      			<ul>
    		<#list root.child?sort_by("productCategoryId") as child>
					      				<li><a href="<@ofbizCatalogAltUrl productCategoryId=child.productCategoryId/>"> <span>-</span> <#if child.categoryName?exists>${child.categoryName?js_string}<#elseif child.categoryDescription?exists>${child.categoryDescription?js_string}<#else>${child.productCategoryId?js_string}</#if></a></li>
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