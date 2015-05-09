<script type="text/javascript">
    function callDocumentByPaginate(info) {
        var str = info.split('~');
        var checkUrl = '<@ofbizUrl>categoryAjaxFired</@ofbizUrl>';
        if(checkUrl.search("http"))
            var ajaxUrl = '<@ofbizUrl>categoryAjaxFired</@ofbizUrl>';
        else
            var ajaxUrl = '<@ofbizUrl>categoryAjaxFiredSecure</@ofbizUrl>';
            
        //jQuerry Ajax Request
        jQuery.ajax({
            url: ajaxUrl,
            type: 'POST',
            data: {"category_id" : str[0], "VIEW_SIZE" : str[1], "VIEW_INDEX" : str[2]},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#div3').html(msg);
            }
        });
     }
     
     function sortOrder(info){
     	alert("a");
     	document.formFilter.sortAscending.value = 'Y';
     	document.formFilter.submit()
     }
</script>


<#macro paginationControls>
    <#assign viewIndexMax = Static["java.lang.Math"].ceil((listSize)?double / viewSize?double) >
      <#if (viewIndexMax?int >= 0)>
						<div class="pagination pagination-right">
							<span class="pull-left">${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
							<ul>
            <#if (viewIndex?int > 0)>
                <li><a class="invarseColor" href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}</@ofbizUrl>">${uiLabelMap.CommonPrevious}</a></a>
            </#if>
                <#list 0..viewIndexMax-1 as curViewNum>
          			<#if curViewNum==viewIndex?int>
								<li class="active"><a class="invarseColor" href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}</@ofbizUrl>">${curViewNum + 1}</a></li>
					<#else>
								<li><a class="invarseColor" href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}</@ofbizUrl>">${curViewNum + 1}</a></li>
					</#if>
                </#list>
            <#if highIndex?int < listSize?int>
             <#-- | <a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int + 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonNext}</a -->
             <li><a class="invarseColor" href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int + 1}</@ofbizUrl>" >${uiLabelMap.CommonNext}</a></li>
            </#if>
							</ul>
						</div><!--end pagination-->
    </#if>
</#macro>

					<div id="featuredItems">
<#if showFilter?exists>
				<form name="formFilter" action="<@ofbizUrl>category/~category_id=${productCategoryId}</@ofbizUrl>" method="post" style="margin:0px">
					
					<div class="productFilter clearfix">
							<input type=hidden name="sortAscending" value="${sortAscending}"/>

						<div class="sortBy inline pull-left">
							${uiLabelMap.CommonSortedBy}:
				          <select name="sortOrder" onchange="javascript:document.formFilter.submit();">
				            <option value="SortKeywordRelevancy" <#if sortOrder?if_exists.equals("SortKeywordRelevancy")>selected="selected"</#if>>${uiLabelMap.ProductKeywordRelevancy}</option>
				            <option value="SortProductField:productName" <#if sortOrder?if_exists.equals("SortProductField:productName")>selected="selected"</#if>>${uiLabelMap.ProductProductName}</option>
				            <option value="SortProductField:internalName" <#if sortOrder?if_exists.equals("SortProductField:internalName")>selected="selected"</#if>>${uiLabelMap.ProductInternalName}</option>
				            <option value="SortProductField:totalQuantityOrdered" <#if sortOrder?if_exists.equals("SortProductField:totalQuantityOrdered")>selected="selected"</#if>>${uiLabelMap.ProductPopularityByOrders}</option>
				            <option value="SortProductField:totalTimesViewed" <#if sortOrder?if_exists.equals("SortProductField:totalTimesViewed")>selected="selected"</#if>>${uiLabelMap.ProductPopularityByViews}</option>
				            <option value="SortProductField:averageCustomerRating" <#if sortOrder?if_exists.equals("SortProductField:averageCustomerRating")>selected="selected"</#if>>${uiLabelMap.ProductCustomerRating}</option>
				            <option value="SortProductPrice:LIST_PRICE" <#if sortOrder?if_exists.equals("SortProductPrice:LIST_PRICE")>selected="selected"</#if>>${uiLabelMap.ProductListPrice}</option>
				            <option value="SortProductPrice:DEFAULT_PRICE" <#if sortOrder?if_exists.equals("SortProductPrice:DEFAULT_PRICE")>selected="selected"</#if>>${uiLabelMap.ProductDefaultPrice}</option>
				            <option value="SortProductPrice:AVERAGE_COST" <#if sortOrder?if_exists.equals("SortProductPrice:AVERAGE_COST")>selected="selected"</#if>>${uiLabelMap.ProductAverageCost}</option>
				          </select>
						</div>

						<div class="showItem inline pull-left">
						  	<button data-title="${uiLabelMap.ProductLowToHigh}" data-placement="top" data-toggle="tooltip" onclick="javascript:document.formFilter.sortAscending.value = 'Y';document.formFilter.submit();" class="btn<#if sortAscending?if_exists.equals("Y")> btn-primary active</#if>"><i class="icon-sort-down"></i></button>
						  	<button data-title="${uiLabelMap.ProductHighToLow}" data-placement="top" data-toggle="tooltip" onclick="javascript:document.formFilter.sortAscending.value = 'N';document.formFilter.submit();" class="btn<#if sortAscending?if_exists.equals("N")> btn-primary active</#if>"><i class="icon-sort-up"></i></button>
						</div>

						<div class="showItem inline pull-left">
							Show
							<select name="viewSize" onchange="javascript:form.submit();">
								<option value="8" <#if viewSize?int==8>selected="selected"</#if>>8</option>
								<option value="16" <#if viewSize?int==16>selected="selected"</#if>>16</option>
								<option value="24" <#if viewSize?int==24>selected="selected"</#if>>24</option>
								<option value="32" <#if viewSize?int==32>selected="selected"</#if>>32</option>
								<option value="40" <#if viewSize?int==40>selected="selected"</#if>>40</option>
							</select>
						</div><!--end sortBy-->

<#assign productCompareList = Static["org.ofbiz.product.product.ProductEvents"].getProductCompareList(request)/>
						<div class="compareItem inline pull-left">
							<button onclick="javascript:popUp('<@ofbizUrl secure="${request.isSecure()?string}">compareProducts</@ofbizUrl>', 'compareProducts', '650', '750')" class="btn">${uiLabelMap.ProductCompareProducts} (${productCompareList.size()})</button>
						</div><!--end compareItem-->
					</div><!--end productFilter-->
			</form>
<#else>					
	<#if productCategory?exists>
	    <#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
	    <#assign categoryDescription = categoryContentWrapper.get("DESCRIPTION")?if_exists/>
	    <#if categoryName?has_content>
	
							<!-- <div class="span12"> -->
							<div class="titleHeader clearfix">
								<h3>${categoryName}</h3>
							</div><!--end titleHeader-->
							<!-- </div> -->
	    </#if>
	</#if>
</#if>

						<div class="row">

<#if productCategoryMembers?has_content>
    <#-- Pagination -->
    <@paginationControls/>

      <#assign numCol = numCol?default(1)>
      <#assign numCol = numCol?number>
      <#assign tabCol = 1>
	<ul class="hProductItems clearfix">
      <#if (numCol?int > 1)>
      </#if>
        <#list productCategoryMembers as productCategoryMember>
          <#if (numCol?int == 1)>
            ${setRequestAttribute("optProductId", productCategoryMember.productId)}
            ${setRequestAttribute("productCategoryMember", productCategoryMember)}
            ${setRequestAttribute("listIndex", productCategoryMember_index)}
            ${screens.render(productsummaryScreen)}
          <#else>
              <#if (tabCol?int = 1)><tr></#if>
                      ${setRequestAttribute("optProductId", productCategoryMember.productId)}
                      ${setRequestAttribute("productCategoryMember", productCategoryMember)}
                      ${setRequestAttribute("listIndex", productCategoryMember_index)}
                      ${screens.render(productsummaryScreen)}
              <#if (tabCol?int = numCol)></tr></#if>
              <#assign tabCol = tabCol+1><#if (tabCol?int > numCol)><#assign tabCol = 1></#if>
           </#if>
        </#list>
      <#if (numCol?int > 1)>
      </#if>
      </ul>

    <@paginationControls/>
<#else>
    <hr />
    <div>${uiLabelMap.ProductNoProductsInThisCategory}</div>
</#if>

						</div><!--end row-->

					</div><!--end featuredItems-->