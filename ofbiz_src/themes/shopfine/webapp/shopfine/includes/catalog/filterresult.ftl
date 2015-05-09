 <#macro paginationControls>
    <#assign viewIndexMax = Static["java.lang.Math"].ceil((listSize - 1)?double / viewSize?double)>
      <#if (viewIndexMax?int > 0)>
            <#-- End Page Select Drop-Down -->
            <#if (viewIndex?int > 0)>
                <#-- a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonPrevious}</a --> |
                <b><a href="<@ofbizUrl>keywordsearch/~category_id=CLOTHINGS_PROMOTIONS/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}/~clearSearch=N</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonPrevious}</a> |</b>
            </#if>
            <#if ((listSize?int - viewSize?int) > 0)>
                <b>${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</b>
            </#if>
            <#if highIndex?int < listSize?int>
             <#-- | <a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int + 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonNext}</a -->
             <b>| <a href="<@ofbizUrl>keywordsearch/~category_id=CLOTHINGS_PROMOTIONS/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex+1}/~clearSearch=N</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonNext}</a></b>
            </#if>
 </#if>
</#macro> 
<div id="cartdiv">
	<div>${uiLabelMap.CommonSortedBy}: ${searchSortOrderString}</div>
	<br />
	<#if !productIds?has_content>
	  <h3>&nbsp;${uiLabelMap.ProductNoResultsFound}.</h3>
	</#if>
		<#if productIds?has_content>
			<div class="product-filter"><b>
		 </div>
		 	<@paginationControls/>
			<div class="product-grid">
				
		        <#list productIds as productId> <#-- note that there is no boundary range because that is being done before the list is put in the content -->
		            ${setRequestAttribute("optProductId", productId)}
		            ${setRequestAttribute("listIndex", productId_index)}
		            ${screens.render(productsummaryScreen)}
		        </#list>
			</div><!--end row-->
		</#if>
	<@paginationControls/>
</div><!--end featuredItems-->
					