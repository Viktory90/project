<div class="span12">
	<div class="row">
	  <a href="<@ofbizUrl>main</@ofbizUrl>" class="linktext">${uiLabelMap.CommonHome}</a> &gt;
	
	    <#-- Show the category branch -->
	    <#assign crumbs = Static["org.ofbiz.product.category.CategoryWorker"].getTrail(request)/>
	    <#list crumbs as crumb>
	         <#if catContentWrappers?exists && catContentWrappers[crumb]?exists>
	
	               <a href="<@ofbizCatalogUrl currentCategoryId=crumb previousCategoryId=previousCategoryId!""/>" class="<#if crumb_has_next>linktext<#else>buttontextdisabled</#if>">
	                 <#if catContentWrappers[crumb].get("CATEGORY_NAME")?exists>
	                   ${catContentWrappers[crumb].get("CATEGORY_NAME")}
	                 <#elseif catContentWrappers[crumb].get("DESCRIPTION")?exists>
	                   ${catContentWrappers[crumb].get("DESCRIPTION")}
	                 <#else>
	                   ${crumb}
	                 </#if>
	               </a>
	
	            <#assign previousCategoryId = crumb />
	         </#if>
	    </#list>    
	    <#-- Show the product, if there is one -->
	    <#if productContentWrapper?exists>
	         &nbsp;&gt; ${productContentWrapper.get("PRODUCT_NAME")?if_exists}
	    </#if>
	</div>
</div>